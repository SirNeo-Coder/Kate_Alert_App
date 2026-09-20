# shared

Data definitions that the student app and the admin web app must both agree on.

Both files here are **empty placeholders**. The real campus data will be supplied
later. JSON does not support comments, so the field definitions are documented
here instead.

---

## `campus_buildings.json`

The list of every building on campus. Expected to be a JSON array; each entry has:

| Field         | Meaning                                                                 |
|---------------|-------------------------------------------------------------------------|
| `name`        | The building's name as students know it.                                  |
| `floors`      | How many floors the building has.                                         |
| `rooms`       | The room numbers on each floor. Keyed by floor, each holding a list of room numbers. |
| `coordinates` | Where the building sits on the map — latitude and longitude.              |

Used by the student app to work out the nearest building from GPS, and to offer
the right floor and room choices. Used by the admin web app to place buildings on
the campus map.

---

## `alert_record.json`

The exact shape of a single alert. Expected to be a JSON object with:

| Field        | Meaning                                                                    |
|--------------|-----------------------------------------------------------------------------|
| `student_id` | Identifies the student who raised the alert — read from their NFC tag.        |
| `building`   | The building name, matching a `name` in `campus_buildings.json`.               |
| `floor`      | The floor the student confirmed.                                               |
| `room`       | The room the student confirmed.                                                |
| `timestamp`  | When the alert was raised.                                                     |
| `status`     | Where the alert stands — e.g. newly raised, acknowledged by an administrator, resolved. |

The student app produces records in this shape; the admin web app reads them.
