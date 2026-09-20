-- Kate_Alert_App — database schema (Supabase / PostgreSQL).
--
-- Run this in the Supabase SQL editor. Kept in the repository so the schema is
-- version-controlled rather than existing only as clicks in the dashboard.
--
-- Mirrors shared/campus_buildings.jsonc and shared/alert_record.jsonc. If a
-- field changes there, change it here too, or the two halves of the system
-- drift apart.

-- One row per school. The system is adaptable to any school; PUP Sta. Mesa is
-- the sample campus used during development.
create table schools (
  id         bigint generated always as identity primary key,
  name       text not null,
  created_at timestamptz not null default now()
);

-- One row per building.
--
-- latitude and longitude are not null on purpose. A building comes into
-- existence when the admin picks it on the Google Map during campus setup, so
-- it always has coordinates from the moment it is created. A building with no
-- location could not appear on the admin map, and could not be proposed as one
-- of the three nearest buildings.
--
-- compound is a field of the building itself, so it travels with the building
-- and is never a separate question the student answers.
create table buildings (
  id          bigint generated always as identity primary key,
  school_id   bigint not null references schools (id),
  name        text not null,
  compound    text,
  latitude    double precision not null,
  longitude   double precision not null,
  floor_count int,
  created_at  timestamptz not null default now(),

  -- Without this, picking the same building twice during setup creates a
  -- duplicate, and the student then sees it twice in the nearest-three list.
  unique (school_id, name)
);

-- One row per enrolled student. This is the roster of issued NFC tags.
--
-- tag_uid is what the phone reads off the student's personal tag. It is unique
-- per school: a tag belongs to exactly one student.
--
-- An alert does NOT have a foreign key to this table on purpose. See the alerts
-- table below.
create table students (
  id             bigint generated always as identity primary key,
  school_id      bigint not null references schools (id),
  student_number text not null,
  full_name      text not null,
  tag_uid        text not null,
  is_active      boolean not null default true,  -- false when a tag is lost, replaced or the student leaves
  created_at     timestamptz not null default now(),

  unique (school_id, student_number),
  unique (school_id, tag_uid)
);

-- One row per emergency alert. Fields mirror shared/alert_record.jsonc.
--
-- The compound is not stored here. It is carried on the building row, so
-- building_id alone determines it.
--
-- NEAREST-BUILDING RULE: when a student raises an alert, GPS does not pick the
-- building outright. It proposes the three nearest buildings and the student
-- confirms which one. Only the confirmed building is stored.
create table alerts (
  id          bigint generated always as identity primary key,
  student_id  text not null,                        -- the tag_uid read from the student's personal NFC tag

  -- student_id is stored as the raw tag_uid, with no foreign key to students.
  -- This is deliberate: an alert from an unrecognised tag must still be
  -- recorded and shown to the admin. A tag missing from the roster is a reason
  -- to flag the alert, never a reason to refuse it. Matching a tag_uid to a
  -- student happens when the alert is read, not when it is written.
  building_id bigint not null references buildings (id),
  floor       int,                                  -- confirmed by the student
  room        text,                                 -- confirmed by the student
  raised_at   timestamptz not null default now(),
  status      text not null default 'new'           -- 'new' | 'acknowledged' | 'resolved' | 'false_alarm'
                                                    -- 'false_alarm' is set by an admin. Counting these per
                                                    -- tag_uid is how repeat false alarms surface; the school
                                                    -- handles them as a discipline matter, not the software.
);

-- Fetching the active alerts for the admin map is the query that runs most.
create index alerts_status_raised_at_idx on alerts (status, raised_at desc);

-- ---------------------------------------------------------------------------
-- ROW-LEVEL SECURITY
--
-- Two kinds of caller:
--
--   anon          the Android student app. Its key ships inside the APK, so
--                 assume anyone with the app has it.
--   authenticated a campus admin, signed in through the web app with Supabase
--                 Auth. Admin accounts are created by the developer in the
--                 Supabase dashboard; there is no public sign-up.
--
-- Nobody else touches the database directly.
-- ---------------------------------------------------------------------------

alter table schools   enable row level security;
alter table students  enable row level security;
alter table buildings enable row level security;
alter table alerts    enable row level security;

-- The student app must read the building list to work out the three nearest
-- buildings, so this is readable without signing in. It is only building names
-- and map coordinates.
create policy "anyone can read schools"
  on schools for select
  using (true);

create policy "anyone can read buildings"
  on buildings for select
  using (true);

-- The roster is NOT readable by the student app. It holds names and student
-- numbers, and the app has no reason to read it -- the tag identifies the
-- student on its own. Only a signed-in admin can see or manage it.
create policy "admins manage students"
  on students for all
  to authenticated
  using (true) with check (true);

-- Campus setup: only a signed-in admin can add or edit buildings.
create policy "admins manage schools"
  on schools for all
  to authenticated
  using (true) with check (true);

create policy "admins manage buildings"
  on buildings for all
  to authenticated
  using (true) with check (true);

-- The student app can raise an alert, and that is all it can do. There is no
-- select policy for anon on alerts, so the app cannot read back any alert --
-- neither its own nor anyone else's.
create policy "student app can raise an alert"
  on alerts for insert
  to anon
  with check (true);

-- Admins see every alert and can change its status.
create policy "admins read alerts"
  on alerts for select
  to authenticated
  using (true);

create policy "admins update alerts"
  on alerts for update
  to authenticated
  using (true) with check (true);

-- Nothing deletes alerts. An alert is resolved by setting its status, not by
-- removing the record.

-- ---------------------------------------------------------------------------
-- KNOWN GAP
--
-- Anyone holding the anon key can insert an alert, so the app can be used to
-- raise false alarms at volume. Nothing here prevents that. Options when it
-- matters: rate-limit inserts, or check the student_id against a roster of
-- issued NFC tags. Not solved now -- see docs/open-items.md.
-- ---------------------------------------------------------------------------
