# Stack

Part of [[README|Kate_Alert_App]].

Hosted online, the same way VMAS is. Not run on a machine at the school.

- **Front end** (the web pages the admin sees) — Vercel
- **Back end and database** — Supabase

Both halves of the system meet at Supabase: the Android app writes an alert into
it, the admin web page reads that alert out.

## Known limit

On Supabase's free plan, a project that sees no activity for several days goes to
sleep and takes a moment to wake on the next request. That is acceptable while
building. A live emergency system would want the paid plan, or something that
pings it regularly to keep it awake.
