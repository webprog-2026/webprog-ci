#!/usr/bin/env bash
# Beadások áttekintése egy házi feladathoz.
#
#   ORG=webprog-2026 ./oktato/report.sh wp-hf01              # táblázat
#   ORG=webprog-2026 ./oktato/report.sh wp-hf01 csv          # CSV, Excelbe másolható
#
# Jelzések:
#   OK      az automatikus ellenőrzés zöld
#   HIBA    piros, van mit javítani
#   FUT     éppen fut
#   ÜRES    a hallgató még nem töltött fel semmit
#   ?       nincs futás (pl. ki van kapcsolva az Actions)

set -uo pipefail

ORG="${ORG:-webprog-2026}"
PREFIX="${1:-}"
FORMAT="${2:-table}"

# A sajat repoink, ezek nem beadasok
SAJAT='(-referencia$|^webprog-ci$|^mobilprog-ci$|-php-alapok$|-alapmuveletek$|-pontszamlalo$)'

if [ -z "$PREFIX" ]; then
  echo "Használat: ORG=<szervezet> $0 <repó-előtag> [csv]" >&2
  echo "Példa:     ORG=webprog-2026 $0 wp-hf01" >&2
  exit 1
fi

repos=$(gh repo list "$ORG" --limit 500 --json name --jq ".[] | select(.name | startswith(\"$PREFIX\")) | .name" | grep -Ev "$SAJAT" | sort)

if [ -z "$repos" ]; then
  echo "Nincs \"$PREFIX\" kezdetű hallgatói repó a(z) $ORG szervezetben." >&2
  exit 1
fi

[ "$FORMAT" = "csv" ] && echo "repo,hallgato,utolso_commit,commitok,ellenorzes,url"

osszes=0
zold=0

while IFS= read -r repo; do
  [ -z "$repo" ] && continue
  osszes=$((osszes + 1))

  # A keszito (a repot letrehozo hallgato)
  hallgato=$(gh api "repos/$ORG/$repo/collaborators?affiliation=direct" \
               --jq '[.[] | select(.permissions.admin and .login != "pallaszlo") | .login] | first // "-"' 2>/dev/null)
  [ -z "$hallgato" ] || [ "$hallgato" = "null" ] && hallgato="-"

  # Utolso commit es a commitok szama
  commits=$(gh api "repos/$ORG/$repo/commits?per_page=100" 2>/dev/null)
  # Ures repo eseten a valasz nem lista, hanem hibaobjektum
  if [ "$(echo "$commits" | cut -c1)" != "[" ]; then
    last="-"
    db=0
    mark="ÜRES  "
    run="ures"
  else
    last=$(echo "$commits" | python -c "
import json,sys
d=json.load(sys.stdin)
print(d[0]['commit']['author']['date'][:16].replace('T',' ') if d else '-')
" 2>/dev/null)
    db=$(echo "$commits" | python -c "import json,sys; print(len(json.load(sys.stdin)))" 2>/dev/null)
    [ -z "$last" ] && last="-"
    [ -z "$db" ] && db=0

    run=$(gh run list -R "$ORG/$repo" --limit 1 --json conclusion,status \
            --jq '.[0] | if .status != "completed" then "fut" else (.conclusion // "-") end' 2>/dev/null)
    [ -z "$run" ] && run="nincs"

    case "$run" in
      success) mark="OK    "; zold=$((zold + 1)) ;;
      failure) mark="HIBA  " ;;
      fut)     mark="FUT   " ;;
      *)       mark="?     " ;;
    esac
  fi

  url="https://github.com/$ORG/$repo"

  if [ "$FORMAT" = "csv" ]; then
    echo "$repo,$hallgato,$last,$db,$run,$url"
  else
    printf '%s %-34s %-22s %-17s %s\n' "$mark" "$repo" "$hallgato" "$last" "${db} commit"
  fi
done <<< "$repos"

if [ "$FORMAT" != "csv" ]; then
  echo
  echo "Beadás: $osszes, ebből zöld: $zold"
fi
