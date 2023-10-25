# GitHub Action: Create/update tag

[![Docker Image CI](https://github.com/rickstaa/action-create-tag/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/rickstaa/action-create-tag/actions)
[![Code quality CI](https://github.com/rickstaa/action-create-tag/workflows/Code%20quality%20CI/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3A%22Code+quality+CI%22)
[![release](https://github.com/rickstaa/action-create-tag/workflows/release/badge.svg)](https://github.com/rickstaa/action-create-tag/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rickstaa/action-create-tag?logo=github&sort=semver)](https://github.com/rickstaa/action-create-tag/releases)

Simple (docker-based) GitHub action that can be used to create/update a tag and push it to the remote.

> [!NOTE]\
> Since this is a docker-based action and [GitHub currently only supports Linux-based containers](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action) running this action on Windows and Mac now needs to be supported (see [#26](https://github.com/rickstaa/action-create-tag/issues/26)).

## Inputs

### `tag`

**Required**. Tag you want to create.

### `message`

**Optional**. Tag message. Default: `Release $TAG`.

### `force_push_tag`

**Optional**. Push tag even if it already exists on the remote. Default: `false`. Please use with care!

### `tag_exists_error`

**Optional**. Whether to throw an error when the tag already exists. Default: `true`. Ignored when `force_push_tag` is `true`.

### `no_verify_tag`

**Optional**. Skips verifying when pushing the tag. Default: `false`. Please use with care!

### `commit_sha`

**Optional**. Specify the commit SHA hash for tagging. By default, it utilizes the `GITHUB_SHA` environment variable, which typically represents the latest commit SHA hash. However, its value ultimately depends on the trigger event of the workflow. For additional details, consult the [GitHub Actions documentation](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#github-context).

### `github_token`

**Optional**. It's no need to specify it if you use checkout@v2. Required for
checkout@v1 action.

## Outputs

### `tag_exists`

A boolean specifying whether the tag already exists.

## Environment variables

### `TAG_EXISTS`

A boolean specifying whether the tag already exists.

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
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: rickstaa/action-create-tag@v1
        id: "tag_create"
        with:
          tag: "latest"
          tag_exists_error: false
          message: "Latest release"

      # Print result using the env variable.
      -  run: |
          echo "Tag already present: ${{ env.TAG_EXISTS }}"

      # Print result using the action output.
      - run: |
          echo "Tag already present: ${{ steps.tag_create.outputs.tag_exists }}"
```

## Contributing

Feel free to open an issue if you have ideas on how to make this GitHub action better or if you want to report a bug! All contributions are welcome. :rocket: Please consult the [contribution guidelines](CONTRIBUTING.md) for more information.
