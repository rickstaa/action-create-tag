# GitHub Action: Create/update tag

[![Docker Image CI](https://github.com/rickstaa/action-create-tag/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/rickstaa/action-create-tag/actions)
[![reviewdog](https://github.com/rickstaa/action-create-tag/workflows/reviewdog/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3Areviewdog)
[![release](https://github.com/rickstaa/action-create-tag/workflows/release/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rickstaa/action-create-tag?logo=github&sort=semver)](https://github.com/rickstaa/action-create-tag/releases)

Simple GitHub action that can be used to create a tag inside a GitHub action.

## Inputs

### `tag`

**Required**. Tag you want to create.

### `message`

**Optional**. Tag message. Default: `Release $TAG`.

### `force_push_tag`

**Optional**. Push tag even if it already exists on the remote. Default: `false`. Please use with care!

### `commit_sha`

**Optional**. The commit SHA hash on which you want to push the tag. Uses latest commit by default.

### `github_token`

**Optional**. It's no need to specify it if you use checkout@v2. Required for
checkout@v1 action.

## Example usage

```yml
name: Create/update tag
on:
  push:
    branch: "main"
jobs:
  create-tag:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: rickstaa/action-create-tag@v1
        with:
          tag: "Latest"
          message: "Latest release"
```
