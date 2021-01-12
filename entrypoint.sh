#!/bin/sh
set -x

cd "${GITHUB_WORKSPACE}" || exit

if [ -z "${INPUT_TAG}" ]; then
  echo "[action-create-tag] No-tag was supplied! Please supply a tag."
  exit 1
fi

# Set up variables.
TAG="${INPUT_TAG}"
MESSAGE="${INPUT_MESSAGE:-Release ${TAG}}"
FORCE_TAG="${INPUT_FORCE_PUSH_TAG:-false}"

# Set up Git credentials
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Update MAJOR/MINOR tag
if [ "${INPUT_FORCE_PUSH_TAG}" == 'true' ]; then
  git tag -fa "${TAG}" -m "${MESSAGE}"
else
  git tag -a "${TAG}" -m "${MESSAGE}"
fi

# Set up remote url for checkout@v1 action.
if [ -n "${INPUT_GITHUB_TOKEN}" ]; then
  git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
fi

# Push tag
if [ "${INPUT_FORCE_PUSH_TAG}" == 'true' ]; then
  git push --force origin "${TAG}"
else
  git push origin "${TAG}"
fi
