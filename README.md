# Kate Alert App

A campus emergency alert system for a university. A student in distress raises an
alert from their phone; campus administrators see it appear on a live map of the
campus, showing which building the student is in.

## How it works

1. The student taps their personal NFC tag against their phone.
2. The phone reads its GPS position and works out the nearest campus building.
3. The student confirms (or corrects) the building, floor and room.
4. The alert is sent, and appears on the administrators' monitoring screen.

## Repository layout

### `student-app/`
The Android phone app carried by students. Written in Java, opened in Android
Studio. Handles NFC tag reading, GPS lookup, the building/floor/room confirmation
screen, and sending the alert.

### `admin-web/`
The monitoring web application used by campus administrators. Shows a campus map
and lists active alerts, indicating which building each student in distress is in.

### `shared/`
Data definitions both halves must agree on: the campus building list and the
format of an alert record. Currently placeholders — the real campus data will be
supplied later.

## Status

Project skeleton only. No application code has been written yet.
