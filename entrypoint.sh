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
ACTION_OUTPUT_MESSAGE="[action-create-tag] Push tag '${TAG}'"
MESSAGE="${INPUT_MESSAGE:-Release ${TAG}}"
FORCE_TAG="${INPUT_FORCE_PUSH_TAG:-false}"
TAG_EXISTS_ERROR="${INPUT_TAG_EXISTS_ERROR:-true}"
NO_VERIFY="${INPUT_NO_VERIFY_TAG:-false}"
SHA=${INPUT_COMMIT_SHA:-${GITHUB_SHA}}

git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# Check if tag already exists.
if [ "$(git tag -l "${TAG}")"  ]; then tag_exists=true; else tag_exists=false; fi
echo "tag_exists=${tag_exists}" >> "${GITHUB_OUTPUT}"
echo "TAG_EXISTS=${tag_exists}" >> "${GITHUB_ENV}"

# Create tag and handle force push action input.
echo "[action-create-tag] Create tag '${TAG}'."
[ "${tag_exists}" = 'true' ] && echo "[action-create-tag] Tag '${TAG}' already exists."
if [ "${FORCE_TAG}" = 'true' ]; then
  [ "${tag_exists}" = 'true' ] && echo "[action-create-tag] Overwriting tag '${TAG}' since 'force_push_tag' is set to 'true'."
  git tag -fa "${TAG}" "${SHA}" -m "${MESSAGE}"
  FLAGS="${FLAGS} --force"
  ACTION_OUTPUT_MESSAGE="${ACTION_OUTPUT_MESSAGE}, with --force"
else
  if [ "${tag_exists}" = 'true' ]; then
    echo "[action-create-tag] Please set 'force_push_tag' to 'true' if you want to overwrite it."
    if [ "${TAG_EXISTS_ERROR}" = 'true' ]; then
      echo "[action-create-tag] Throwing an error. Please set 'tag_exists_error' to 'false' if you want to ignore this error."
      exit 1
    fi
    echo "[action-create-tag] Ignoring error since 'tag_exists_error' is set to 'false'."
  else
    git tag -a "${TAG}" "${SHA}" -m "${MESSAGE}"
  fi
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
[ "${tag_exists}" = 'true' ] && [ "${FORCE_TAG}" = 'false' ] && exit 0
echo "${ACTION_OUTPUT_MESSAGE}"
# shellcheck disable=SC2086
git push $FLAGS origin "$TAG"
