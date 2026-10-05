#!/usr/bin/env bash
# A hallgatói repók nevének ellenőrzése (és javítása).
#
#   ORG=webprog-2026 ./oktato/nevek.sh wp-hf01               # csak jelent
#   ORG=webprog-2026 ./oktato/nevek.sh wp-hf01 --javit       # át is nevezi
#
# Az elvárt név: <elotag>-<githubfelhasznalonev>
#
# A szkript csak az adott előtagú repókat nézi (pl. wp-hf02-...), és kihagyja a sajátjainkat
# (sablonok, referenciák, ci). Ami marad, az hallgatói munka: ezeknél
# megnézi, hogy a név a készítő felhasználónevével végződik-e.
#
# Átnevezéskor a GitHub a régi címről átirányít, tehát a hallgató klónja
# és a push is működik tovább.

set -uo pipefail

ORG="${ORG:-webprog-2026}"
PREFIX="${1:-}"
MODE="${2:-jelentes}"

if [ -z "$PREFIX" ]; then
  echo "Használat: ORG=<szervezet> $0 <repo-elotag> [--javit]" >&2
  exit 1
fi

# A sajat repoink, ezeket kihagyjuk
SAJAT='(-referencia$|^webprog-ci$|^mobilprog-ci$|-php-alapok$|-alapmuveletek$|-pontszamlalo$|-fuggvenyek-tombok$)'

hibas=0
rendben=0

while IFS=$'\t' read -r repo owner; do
  [ -z "$repo" ] && continue
  echo "$repo" | grep -qE "$SAJAT" && continue

  # A repo keszitoje: az elso admin jogu tag, aki nem a szervezet tulajdonosa
  keszito=$(gh api "repos/$ORG/$repo/collaborators?affiliation=direct" \
              --jq '[.[] | select(.login != "pallaszlo") | .login] | first' 2>/dev/null)

  elvart="$PREFIX-$keszito"

  if [ -z "$keszito" ] || [ "$keszito" = "null" ]; then
    echo "?       $repo (nem tudom, ki hozta létre)"
    continue
  fi

  if [ "$repo" = "$elvart" ]; then
    rendben=$((rendben + 1))
    continue
  fi

  hibas=$((hibas + 1))
  echo "ELTÉR   $repo"
  echo "        készítette: $keszito, helyes név: $elvart"

  if [ "$MODE" = "--javit" ]; then
    if gh api -X PATCH "repos/$ORG/$repo" -f name="$elvart" >/dev/null 2>&1; then
      echo "        átnevezve: $elvart"
    else
      echo "        HIBA: az átnevezés nem sikerült"
    fi
  fi
done < <(gh repo list "$ORG" --limit 500 --json name,owner --jq ".[] | select(.name | startswith(\"$PREFIX-\")) | [.name, .owner.login] | @tsv")

echo
echo "Rendben: $rendben, eltérő: $hibas"
[ "$MODE" != "--javit" ] && [ "$hibas" -gt 0 ] && echo "Javítás: $0 $PREFIX --javit"
exit 0
