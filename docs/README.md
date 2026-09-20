# Kate_Alert_App

A campus emergency alert system. A student carries a personal NFC tag unique to
them. In an emergency the student scans their own tag with a phone app. The app
reads GPS, proposes the three nearest campus buildings, and the student confirms
which building, then the floor and room. The alert appears on an admin web app
showing a campus map with the location of anyone needing help.

Three nearest rather than one: emergencies happen indoors, where GPS is weakest.
Walls and upper floors scatter the signal, so a reading can be 30 to 50 metres
off. GPS narrows the list; the student decides.

## Scope

The system is built to be adaptable to any school. It is not built only for PUP
Sta. Mesa — PUP is the sample campus used during development. An adopting school
does its own initial setup, entering its building names, possibly by someone
walking through the campus.

## Repository layout

    student-app/   the Android phone app
    admin-web/     the monitoring web app
    shared/        the campus building list and the alert record format, which
                   both halves must agree on so they cannot drift apart
    docs/          these notes

Programming happens in Claude Code. Planning and discussion happen in the Claude
Project of the same name.

## Notes

- [[stack]] — hosting, back end and database
- [[student-app]] — the Android phone app
- [[admin-web]] — the monitoring and campus setup web app
- [[nfc-tags]] — choosing the tags, and tag cloning
- [[pup-sta-mesa-campus]] — the sample campus data
- [[open-items]] — decisions set aside, and data still missing
