#!/usr/bin/env bash
# Triggers pipelines across branches to generate CircleCI test data.
# Usage: CIRCLE_TOKEN=<personal API token> ./generate-data.sh [runs-per-branch] [delay-seconds]
set -euo pipefail

: "${CIRCLE_TOKEN:?Set CIRCLE_TOKEN to a CircleCI personal API token}"
PROJECT_SLUG="${PROJECT_SLUG:-gh/DamoCi/circleci-demo-workflows}"
RUNS="${1:-3}"
DELAY="${2:-30}"
BRANCHES=(master develop feature/test-data)

for ((i = 1; i <= RUNS; i++)); do
  for branch in "${BRANCHES[@]}"; do
    echo "Run $i/$RUNS: triggering $branch"
    curl -s -X POST \
      -H "Circle-Token: $CIRCLE_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"branch\":\"$branch\"}" \
      "https://circleci.com/api/v2/project/$PROJECT_SLUG/pipeline"
    echo
  done
  [ "$i" -lt "$RUNS" ] && sleep "$DELAY"
done
