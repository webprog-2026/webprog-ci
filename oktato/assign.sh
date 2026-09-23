#!/usr/bin/env bash
# Házi feladat kiosztása: minden hallgatónak saját repó a sablonból.
# A GitHub Classroom helyett, ami 2026. augusztus 28-án megszűnt.
#
#   ./oktato/assign.sh wp-hf01-php-alapok wp-hf01 nevsor.txt
#
#   1. paraméter: a sablon repó neve a szervezetben
#   2. paraméter: a létrejövő repók előtagja  (wp-hf01-<githubnev>)
#   3. paraméter: névsor, soronként egy GitHub felhasználónév
#                 (a # kezdetű sorok és az üres sorok kimaradnak)
#
# A hallgató "push" jogot kap, nem admint, így nem tudja törölni a repót
# és nem tudja kikapcsolni az Actions-t. Meghívót kap e-mailben.
#
# A szkript újrafuttatható: a meglévő repókat kihagyja.

set -uo pipefail

ORG="${ORG:-webprog-2026}"
TEMPLATE="${1:-}"
PREFIX="${2:-}"
ROSTER="${3:-}"

if [ -z "$TEMPLATE" ] || [ -z "$PREFIX" ] || [ -z "$ROSTER" ]; then
  echo "Használat: $0 <sablon-repo> <repo-elotag> <nevsor-fajl>" >&2
  echo "Példa:     $0 wp-hf01-php-alapok wp-hf01 nevsor.txt" >&2
  exit 1
fi

if [ ! -f "$ROSTER" ]; then
  echo "Nincs ilyen névsorfájl: $ROSTER" >&2
  exit 1
fi

if ! gh repo view "$ORG/$TEMPLATE" >/dev/null 2>&1; then
  echo "Nincs ilyen sablon repó: $ORG/$TEMPLATE" >&2
  exit 1
fi

created=0
skipped=0
failed=0

while IFS= read -r line || [ -n "$line" ]; do
  user=$(echo "$line" | tr -d '\r' | sed 's/#.*//' | xargs)
  [ -z "$user" ] && continue

  repo="$PREFIX-$user"

  if gh repo view "$ORG/$repo" >/dev/null 2>&1; then
    echo "KIHAGY  $repo (már létezik)"
    skipped=$((skipped + 1))
    continue
  fi

  if ! gh repo create "$ORG/$repo" --private --template "$ORG/$TEMPLATE" >/dev/null 2>&1; then
    echo "HIBA    $repo (a repó létrehozása nem sikerült)"
    failed=$((failed + 1))
    continue
  fi

  if gh api -X PUT "repos/$ORG/$repo/collaborators/$user" -f permission=push >/dev/null 2>&1; then
    echo "OK      $repo -> meghívva: $user"
    created=$((created + 1))
  else
    echo "FIGYELEM $repo létrejött, de a(z) $user meghívása nem sikerült (elgépelt felhasználónév?)"
    failed=$((failed + 1))
  fi
done < "$ROSTER"

echo
echo "Létrehozva: $created, kihagyva: $skipped, hibás: $failed"
echo "A hallgatók e-mailben kapnak meghívót, és itt is elfogadhatják: https://github.com/$ORG/<repó>/invitations"
