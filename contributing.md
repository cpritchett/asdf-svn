# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# Test this plugin
ASDF_SVN_BUILD_FROM_SOURCE=true asdf plugin test svn https://github.com/cpritchett/asdf-svn.git "svn --version"
```

Tests are automatically run in GitHub Actions on push and PR.
