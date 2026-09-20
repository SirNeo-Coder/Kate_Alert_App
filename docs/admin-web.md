# Admin web app

Part of [[README|Kate_Alert_App]]. Lives in `admin-web/`.

Does two jobs.

## Monitoring

Shows a campus map indicating who needs help and which building they are in.

## Campus setup

This is where a school sets itself up. The screen shows a Google Map preview of
whatever campus is being set up. Buildings are assigned names, floor counts, and
the rooms on each floor.

Because the map is already open, clicking a building on it is also how that
building's latitude and longitude get recorded — the map hands the coordinates
over, so they never have to be typed by hand.

What the map cannot supply: how many floors a building has, and what its rooms
are numbered. That has to come from the school.

## Compounds

A building's compound is one of the building's own fields. It travels with the
building automatically and is never a separate question the student answers. This
also prevents two buildings in different compounds being confused for each other.
