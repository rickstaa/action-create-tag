#!/bin/sh
set -eu

# Apply hotfix for 'fatal: unsafe repository' error (see #10).
git config --global --add safe.directory "${GITHUB_WORKSPACE}"

cd "${GITHUB_WORKSPACE}" || exit

if [ -z "${INPUT_TAG}" ]; then
  echo "[action-create-tag] No-tag was supplied! Please supply a tag."
  exit 1
fi

# Set up variables.
FLAGS=""
TAG=$(echo "${INPUT_TAG}" | sed 's/ /_/g')
ACTION_OUTPUT_MESSAGE="[action-create-tag] Push tag ${TAG}"
MESSAGE="${INPUT_MESSAGE:-Release ${TAG}}"
FORCE_TAG="${INPUT_FORCE_PUSH_TAG:-false}"
NO_VERIFY="${INPUT_NO_VERIFY_TAG:-false}"
SHA=${INPUT_COMMIT_SHA:-${GITHUB_SHA}}

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Create tag and handle force push action input.
echo "[action-create-tag] Create tag '${TAG}'."
if [ "${FORCE_TAG}" = 'true' ]; then
  git tag -fa "${TAG}" "${SHA}" -m "${MESSAGE}"
  FLAGS="${FLAGS} --force"
  ACTION_OUTPUT_MESSAGE="${ACTION_OUTPUT_MESSAGE}, with --force"
else
  git tag -a "${TAG}" "${SHA}" -m "${MESSAGE}"
fi

# Set up remote url for checkout@v1 action.
if [ -n "${INPUT_GITHUB_TOKEN}" ]; then
  git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
fi

# Handle no-verify action input.
if [ "${NO_VERIFY}" = 'true' ]; then
  FLAGS="${FLAGS} --no-verify"
  ACTION_OUTPUT_MESSAGE="${ACTION_OUTPUT_MESSAGE}, with --no-verify"
fi

# Push tag.
echo "${ACTION_OUTPUT_MESSAGE}"
git push $FLAGS origin "$TAG"
