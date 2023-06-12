# Wick  Push Action
Github action for pushing wick components and applications package for distribution.

# Overview

A Github action to automate packaging and pushing a Wick package (component or application) to a supported registry, such as https://registry.candle.dev.

Not every OCI registry supports the artifact format that is used by Wick, so Candle (https://candle.dev) has created a free registry that supports it. You can sign up for a free account at https://registry.candle.dev.  If you have a different registry that you need to use, the push command will target any registry that is defined in your `package` directive in your component or application configuration.

If you are using Candle registry: When you create your account, you can look at your profile and see the `secret` that can be used for the password.  Make sure you have created a "New Project" in the Candle registry before you attempt to push.


# Usage
```
- name: Package and push
  uses: candlecorp/wick-push-action@v1
  with:
    path: "app.wick"
    username: ${{ secrets.REGISTRY_USERNAME }}
    password: ${{ secrets.REGISTRY_PASSWORD }}
    tags: latest
```

## Inputs

### `path`

**Description:** Path to the component or application `.wick` file. This file contains the registry configuration details.

**Required:** true

**Default:** `app.wick`

### `username`

**Description:** Username for registry

**Required:** true

### `password`

**Description:** Password for registry

**Required:** true

### `tags`

**Description:** space separated list of tags to add to the package in addition to the version. ex: `latest 123456`

**Required:** false

## Outputs

### `reference`
**Description:** The image reference that was pushed

# License

The scripts and documentation in this project are released under the Apache License 2.0.
