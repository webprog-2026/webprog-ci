#!/usr/bin/env bash
# Meghívók kiküldése a szervezetbe e-mail cím alapján.
#
#   ORG=webprog-2026 ./oktato/meghivo.sh emailek.txt            # PRÓBA: csak kiírja, kinek menne
#   ORG=webprog-2026 ./oktato/meghivo.sh emailek.txt --kuldes   # tényleges kiküldés
#
# A fájlban soronként egy e-mail cím, a # utáni rész megjegyzés.
# A már meghívott vagy már tag címeket kihagyja, tehát újrafuttatható.
#
# A meghívó 7 nap után lejár. A függőben lévők itt láthatók:
#   https://github.com/orgs/<ORG>/people/pending_invitations

set -uo pipefail

ORG="${ORG:-webprog-2026}"
FILE="${1:-}"
MODE="${2:-proba}"

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "Használat: ORG=<szervezet> $0 <email-fajl> [--kuldes]" >&2
  exit 1
fi

if ! gh api "orgs/$ORG" >/dev/null 2>&1; then
  echo "Nincs ilyen szervezet, vagy nincs hozzá jogosultság: $ORG" >&2
  exit 1
fi

# Már függőben lévő meghívók e-mail címei
pending=$(gh api --paginate "orgs/$ORG/invitations" --jq '.[].email // empty' 2>/dev/null | tr 'A-Z' 'a-z')

if [ "$MODE" = "--kuldes" ]; then
  echo "KIKÜLDÉS a(z) $ORG szervezetbe"
else
  echo "PRÓBAFUTTATÁS (semmi nem megy ki). Kiküldés: $0 $FILE --kuldes"
fi
echo

sent=0
skipped=0
failed=0

while IFS= read -r line || [ -n "$line" ]; do
  email=$(echo "$line" | tr -d '\r' | sed 's/#.*//' | xargs | tr 'A-Z' 'a-z')
  [ -z "$email" ] && continue

  if echo "$pending" | grep -qx "$email"; then
    echo "KIHAGY  $email (már van függőben lévő meghívója)"
    skipped=$((skipped + 1))
    continue
  fi

  if [ "$MODE" != "--kuldes" ]; then
    echo "MENNE   $email"
    sent=$((sent + 1))
    continue
  fi

  if gh api -X POST "orgs/$ORG/invitations" -f "email=$email" -f 'role=direct_member' >/dev/null 2>&1; then
    echo "OK      $email"
    sent=$((sent + 1))
  else
    echo "HIBA    $email (a meghívó nem ment ki)"
    failed=$((failed + 1))
  fi
done < "$FILE"

echo
if [ "$MODE" = "--kuldes" ]; then
  echo "Kiküldve: $sent, kihagyva: $skipped, hibás: $failed"
  echo "Állapot: https://github.com/orgs/$ORG/people/pending_invitations"
else
  echo "Kimenne: $sent, kihagyva: $skipped"
fi
