# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# Example for testing this plugin
asdf plugin test svn https://github.com/cpritchett/asdf-svn.git "svn --version"
# This command tests the 'svn' plugin by running the 'svn --version' command.
# Expected output:
# svn, version X.Y.Z (r123456)
#    compiled May 1 2023, 12:34:56
# Replace 'X.Y.Z' and other details with the actual version and build information for your setup.
```

Tests are automatically run in GitHub Actions on push and PR.
