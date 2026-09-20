# Student app

Part of [[README|Kate_Alert_App]]. Lives in `student-app/`.

The phone app a student uses to raise an alert. Each student carries a personal
NFC tag unique to them and scans their own tag.

## Decisions

**Android only, written in Java.** Android gives the app full direct access to
read an NFC tag the instant the phone touches it; Apple restricts this. Java also
matches what is already taught in class.

**Built in Android Studio, not VS Code.** Android Studio handles building the
app, pushing it to a phone over USB, and showing live errors. VS Code would need
all of that configured by hand.

**Tested on a real Android phone with NFC over a USB cable.** The built-in
simulated phone cannot scan a real tag and its GPS is faked.

## Open

An anonymity toggle is wanted: an alert can either be anonymous or show the
student's name, rather than the system being fixed to one behaviour. How it
behaves is not yet decided — see [[open-items]].
