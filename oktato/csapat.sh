#!/usr/bin/env bash
# A szervezet tagjainak beléptetése a "hallgatok" csapatba.
#
#   ORG=webprog-2026 ./oktato/csapat.sh
#   ORG=mobilprog-2026 ./oktato/csapat.sh
#
# Miért kell: a szervezetben az alapértelmezett jogosultság "none", tehát a tagok
# maguktól semmit nem látnak. A sablon repókat a "hallgatok" csapat olvashatja.
# Aki most fogadja el a meghívót, az még nincs a csapatban - ez a szkript pótolja.
#
# Futtasd a meghívók kiküldése után néhány naponta, illetve új hallgató érkezésekor.
# Újrafuttatható: aki már bent van, azt kihagyja.

set -uo pipefail

ORG="${ORG:-webprog-2026}"
TEAM="${TEAM:-hallgatok}"
OKTATOK="${OKTATOK:-pallaszlo}"   # szóközzel elválasztva, ezeket nem lépteti be

if ! gh api "orgs/$ORG/teams/$TEAM" >/dev/null 2>&1; then
  echo "Nincs \"$TEAM\" csapat a(z) $ORG szervezetben." >&2
  exit 1
fi

meglevo=$(gh api --paginate "orgs/$ORG/teams/$TEAM/members" --jq '.[].login' 2>/dev/null)

added=0
skipped=0

for user in $(gh api --paginate "orgs/$ORG/members" --jq '.[].login'); do
  if echo " $OKTATOK " | grep -q " $user "; then
    continue
  fi

  if echo "$meglevo" | grep -qx "$user"; then
    skipped=$((skipped + 1))
    continue
  fi

  if gh api -X PUT "orgs/$ORG/teams/$TEAM/memberships/$user" -f role=member >/dev/null 2>&1; then
    echo "OK      $user beléptetve"
    added=$((added + 1))
  else
    echo "HIBA    $user beléptetése nem sikerült"
  fi
done

echo
echo "Beléptetve: $added, már bent volt: $skipped"

echo
echo "A csapat által olvasható repók:"
gh api --paginate "orgs/$ORG/teams/$TEAM/repos" --jq '.[] | "  " + .name + " (" + (.permissions | to_entries | map(select(.value)) | map(.key) | join(",")) + ")"' 2>/dev/null
