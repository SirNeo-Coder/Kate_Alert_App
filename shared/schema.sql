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
  student_id  text not null,                        -- read from the student's personal NFC tag
  building_id bigint not null references buildings (id),
  floor       int,                                  -- confirmed by the student
  room        text,                                 -- confirmed by the student
  raised_at   timestamptz not null default now(),
  status      text not null default 'new'           -- 'new' | 'acknowledged' | 'resolved'
);

-- Fetching the active alerts for the admin map is the query that runs most.
create index alerts_status_raised_at_idx on alerts (status, raised_at desc);

-- ---------------------------------------------------------------------------
-- ROW-LEVEL SECURITY
--
-- Not written yet, deliberately. Supabase locks every table until policies are
-- added, so nothing can read or write these tables as they stand.
--
-- What the policies have to account for: the Android app talks to Supabase with
-- the public anon key, which ships inside the APK and should be assumed
-- readable by anyone who has the app. So the student app must be able to INSERT
-- an alert, but must not be able to read other students' alerts. The admin side
-- must be able to read everything, which means the admin has to authenticate as
-- something other than anon.
--
-- This depends on how admin sign-in works, which is not decided. See
-- docs/open-items.md.
-- ---------------------------------------------------------------------------
