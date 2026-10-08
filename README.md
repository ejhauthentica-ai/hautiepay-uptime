# hautiepay.ca uptime check

Every ~5 minutes GitHub Actions runs `check.sh` against https://hautiepay.ca:

- `/up`, the home page and `/help-center` answer 200;
- card payments are in live mode;
- the HTTPS certificate has at least 14 days left.

Two failures in a row (30 s apart) open an issue labelled **outage**, assigned to the
repository owner, so GitHub emails them. When the site passes again the issue is closed
with a comment, which emails again. Runs off-site on purpose: a check on the same server
could not report that server being down.

To test it: Actions → "hautiepay.ca uptime" → Run workflow.
