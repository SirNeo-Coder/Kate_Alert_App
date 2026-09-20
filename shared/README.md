# shared

Data definitions that the student app and the admin web app must both agree on.

Both files use **JSONC** (JSON with comments), so the field definitions and rules
live alongside the data itself. The documentation below mirrors the comments in
those files.

---

## `campus_buildings.jsonc`

Every building at PUP Sta. Mesa. A JSON array; each entry has:

| Field        | Meaning                                                        |
|--------------|-----------------------------------------------------------------|
| `name`       | The building's name as students know it.                          |
| `compound`   | One of `A. Mabini`, `NDC Compound`, `M.H. Del Pilar`.             |
| `latitude`   | Decimal degrees, north positive. **Not yet supplied.**            |
| `longitude`  | Decimal degrees, east positive. **Not yet supplied.**             |
| `floors`     | How many floors the building has. **Not yet supplied.**           |
| `rooms`      | Floor number to list of room numbers. **Not yet supplied.**       |

The campus is three separate compounds, and every building record carries its own
compound name. The compound is therefore never a separate question the student
answers — confirming the building already determines the compound.

### Main Academic Building

Divided into wings: **North Wing** and **South Wing**. Its rooms are numbered with
the floor as the first digit — Room 420 is on the 4th floor. The wing is part of
how a room is located, so the room list must distinguish North from South when
it is filled in.

### Buildings currently listed

- **A. Mabini** — Main Academic Building; Ninoy Aquino Library and Learning
  Resources Center; PUP Gym; PUP Grandstand and Oval; Laboratory High School;
  Interfaith Chapel; Charlie del Rosario Student Development Center;
  Amphitheater; PUP ICT Center
- **NDC Compound** — College of Architecture and Fine Arts; College of
  Engineering; College of Communications; MassCom Theater; College of Technology
- **M.H. Del Pilar** — Graduate School; Hasmin Hostel; College of Nutrition and
  Food Science; College of Tourism and Hospitality Management

---

## `alert_record.jsonc`

The shape of a single alert:

| Field        | Meaning                                                                    |
|--------------|-----------------------------------------------------------------------------|
| `student_id` | Identifies the student who raised the alert — read from their NFC tag.        |
| `building`   | The building name, matching a `name` in `campus_buildings.jsonc`.              |
| `floor`      | The floor the student confirmed.                                               |
| `room`       | The room the student confirmed.                                                |
| `timestamp`  | When the alert was raised.                                                     |
| `status`     | Where the alert stands — e.g. newly raised, acknowledged, resolved.            |

The compound is not stored on the alert. It is carried on the building record, so
the building name alone determines it.

### Nearest-building rule

When a student raises an alert, GPS does **not** pick the building outright. It
proposes the **three nearest buildings**, and the student confirms which of the
three they are in.

Recorded here so the rule is not lost. The logic that finds the three nearest
buildings has not been written yet.
