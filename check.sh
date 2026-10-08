#!/usr/bin/env bash
# One pass over hautiepay.ca. Prints one line per problem; exit 1 if any.
set -u
fail=0
problem() { echo "- $1"; fail=1; }

for url in https://hautiepay.ca/up https://hautiepay.ca/ https://hautiepay.ca/help-center; do
  code=$(curl -s -o /dev/null -m 25 -w '%{http_code}' "$url" || echo 000)
  [ "$code" = "200" ] || problem "$url answered $code (expected 200)"
done

# Card payments must stay on the live gateway.
cfg=$(curl -s -m 25 https://hautiepay.ca/api/authorize-net-config || true)
echo "$cfg" | grep -q '"sandbox":false' || problem "card payments are not in live mode (authorize-net-config: ${cfg:0:80})"

# HTTPS certificate: warn when it has under 14 days left.
end=$(echo | openssl s_client -connect hautiepay.ca:443 -servername hautiepay.ca 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
if [ -z "$end" ]; then
  problem "could not read the HTTPS certificate"
else
  days=$(( ( $(date -d "$end" +%s) - $(date +%s) ) / 86400 ))
  [ "$days" -ge 14 ] || problem "HTTPS certificate expires in $days days ($end)"
fi

exit $fail
