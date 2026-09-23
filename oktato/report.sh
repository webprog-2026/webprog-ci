#!/usr/bin/env bash
# Beadások áttekintése egy házi feladathoz.
#
#   ./oktato/report.sh wp-hf01            # táblázat a terminálba
#   ./oktato/report.sh wp-hf01 csv        # CSV, Excelbe másolható
#
# Az ORG környezeti változóval más szervezet is megadható.

set -uo pipefail

ORG="${ORG:-webprog-2026}"
PREFIX="${1:-}"
FORMAT="${2:-table}"

if [ -z "$PREFIX" ]; then
  echo "Használat: $0 <repó-előtag> [csv]" >&2
  echo "Példa:     $0 wp-hf01" >&2
  exit 1
fi

repos=$(gh repo list "$ORG" --limit 500 --json name --jq ".[] | select(.name | startswith(\"$PREFIX\")) | .name" | sort)

if [ -z "$repos" ]; then
  echo "Nincs \"$PREFIX\" kezdetű repó a(z) $ORG szervezetben." >&2
  exit 1
fi

[ "$FORMAT" = "csv" ] && echo "repo,utolso_commit,ellenorzes,url"

while IFS= read -r repo; do
  [ -z "$repo" ] && continue

  last=$(gh api "repos/$ORG/$repo/commits?per_page=1" --jq '.[0].commit.author.date' 2>/dev/null | cut -c1-16 | tr 'T' ' ')
  [ -z "$last" ] && last="nincs commit"

  run=$(gh run list -R "$ORG/$repo" --limit 1 --json conclusion,status --jq '.[0] | if .status != "completed" then "fut" else (.conclusion // "-") end' 2>/dev/null)
  [ -z "$run" ] && run="nincs futás"

  case "$run" in
    success) mark="OK     " ;;
    failure) mark="HIBA   " ;;
    fut)     mark="FUT    " ;;
    *)       mark="?      " ;;
  esac

  url="https://github.com/$ORG/$repo"

  if [ "$FORMAT" = "csv" ]; then
    echo "$repo,$last,$run,$url"
  else
    printf '%s %-52s %s\n' "$mark" "$repo" "$last"
  fi
done <<< "$repos"
