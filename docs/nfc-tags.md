# NFC tags

Part of [[README|Kate_Alert_App]].

Each student carries a personal NFC tag unique to them and scans their own tag
to raise an alert. The tag is the student's identity in the system, which makes
the choice of tag a security decision, not just a purchasing one.

## The problem

A plain NTAG213/215/216 stores a UID and some data, both freely readable. Tags
with a writable UID are sold openly, so a tag can be read and an identical copy
written. Anything where the tag simply hands over a fixed number is copyable, no
matter how the app is written.

A cloned tag means alerts raised in someone else's name.

## Options, cheapest first

**NTAG21x with originality signature.** NXP's NTAG chips carry an ECC signature
burned in at the factory, verifiable against NXP's public key. It does not stop
the UID being copied, but it stops copying onto a blank magic tag, because the
signature cannot be forged. Same price as the tags already being considered.
Blocks the casual attack, not a determined one.

**NTAG 424 DNA.** Every tap generates a fresh AES-signed code, different each
time. A clone would have to produce the next valid code without holding the key.
A few times the price of an NTAG213, which is negligible at campus scale.

**MIFARE DESFire EV2/EV3.** Mutual authentication with per-tag diversified keys.
More secure, more expensive, considerably more work to implement.

**Tap counter.** Some tags carry a read counter that only increments. A tag
presenting a counter lower than the last one recorded is a clone. Cheap to add
on top of the options above, and catches duplication after the fact.

## The architectural catch

Verifying any of this needs a secret key, and that key cannot live in the
Android app — an APK can be unpacked. Verification has to happen server side, in
a Supabase edge function the app calls. This is a real addition to the design
and is the reason the chip is worth choosing early.

## Recommendation

NTAG 424 DNA, verified in an edge function, combined with device binding from
enrollment. The tag proves it is genuine; the device proves it is the enrolled
student's phone. A cloned tag on an unenrolled phone fails both checks.

For a project with a deadline this is a meaningful detour. The cheaper path is
NTAG213, device binding, and the fact that every alert is already traceable —
with false alarms handled as a discipline matter rather than a software one.
That is weaker, and is defensible only if the limitation is stated plainly
rather than hidden.

Either way: buy 424 DNA. The price difference is trivial and it keeps the
option open even if verification is implemented later. Which tags are bought is
the part that is hard to reverse.
