# GitHub Action: Create/update tag

[![Docker Image CI](https://github.com/rickstaa/action-create-tag/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/rickstaa/action-create-tag/actions)
[![Code quality CI](https://github.com/rickstaa/action-create-tag/workflows/Code%20quality%20CI/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3A%22Code+quality+CI%22)
[![release](https://github.com/rickstaa/action-create-tag/workflows/release/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rickstaa/action-create-tag?logo=github&sort=semver)](https://github.com/rickstaa/action-create-tag/releases)

Simple (docker-based) GitHub action that can be used to create/update a tag and push it to the remote.

> **Note:**
> Since this is a docker-based action and GitHub currently only supports Linux-based containers running this action on Windows and Mac now needs to be supported (see #26).

## Inputs

### `tag`

**Required**. Tag you want to create.

### `message`

**Optional**. Tag message. Default: `Release $TAG`.

### `force_push_tag`

**Optional**. Push tag even if it already exists on the remote. Default: `false`. Please use with care!

### `no_verify_tag`

**Optional**. Skips verifying when pushing the tag. Default: `false`. Please use with care!

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
      - uses: actions/checkout@v3
      - uses: rickstaa/action-create-tag@v1
        with:
          tag: "latest"
          message: "Latest release"
```

## Contributing

Feel free to open an issue if you have ideas on how to make this GitHub action better or if you want to report a bug! All contributions are welcome. :rocket: Please consult the [contribution guidelines](CONTRIBUTING.md) for more information.
