# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# Example for testing this plugin
asdf plugin test svn https://github.com/cpritchett/asdf-svn.git "svn --version"
```

Tests are automatically run in GitHub Actions on push and PR.
