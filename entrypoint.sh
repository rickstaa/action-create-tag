#!/bin/sh
set -eu

# Apply hotfix for 'fatal: unsafe repository' error (see #10)
git config --global --add safe.directory "${GITHUB_WORKSPACE}"

cd "${GITHUB_WORKSPACE}" || exit

if [ -z "${INPUT_TAG}" ]; then
  echo "[action-create-tag] No-tag was supplied! Please supply a tag."
  exit 1
fi

# Set up variables.
TAG="${INPUT_TAG}"
MESSAGE="${INPUT_MESSAGE:-Release ${TAG}}"
FORCE_TAG="${INPUT_FORCE_PUSH_TAG:-false}"
NO_VERIFY="${INPUT_NO_VERIFY_TAG:-false}"
SHA=${INPUT_COMMIT_SHA:-${GITHUB_SHA}}

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Create tag
echo "[action-create-tag] Create tag '${TAG}'."
if [ "${FORCE_TAG}" = 'true' ]; then
  git tag -fa "${TAG}" "${SHA}" -m "${MESSAGE}"
else
  git tag -a "${TAG}" "${SHA}" -m "${MESSAGE}"
fi

# Set up remote url for checkout@v1 action.
if [ -n "${INPUT_GITHUB_TOKEN}" ]; then
  git remote set-url origin "https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
fi

FLAGS=""
MESSAGE="action-create-tag] Push tag ${TAG}"
if ["${FORCE_TAG}" = 'true' ]; then
  FLAGS="${FLAGS} --force"
  MESSAGE="$MESSAGE, with --foce"
fi
if ["${NO_VERIFY}" = 'true' ]; then
  FLAGS="${FLAGS} --no-verify"
  MESSAGE="$MESSAGE, with --no-verify"
fi

# Push tag
echo $MESSAGE
git push tag $FLAGS origin "$TAG"