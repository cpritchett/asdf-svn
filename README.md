<div align="center">

# asdf-svn [![Build](https://github.com/cpritchett/asdf-svn/actions/workflows/build.yml/badge.svg)](https://github.com/cpritchett/asdf-svn/actions/workflows/build.yml) [![Lint](https://github.com/cpritchett/asdf-svn/actions/workflows/lint.yml/badge.svg)](https://github.com/cpritchett/asdf-svn/actions/workflows/lint.yml)

[svn](https://svnbook.red-bean.com/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Extension Commands](#extension-commands)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
- Build dependencies:
  - `apr` and `apr-util` - Apache Portable Runtime libraries
  - `autoconf`, `automake`, `libtool` - GNU build tools
  - `pkg-config` - Compiler/linker package configuration tool
  - `gcc`, `make` - Compiler and build system
  - `openssl` - For SSL/TLS support
  - `sqlite3` - For repository support

These dependencies should be installed using your system's package manager (e.g., Homebrew on macOS, apt on Debian/Ubuntu, etc.).

# Install

Plugin:

```shell
asdf plugin add svn
# or
asdf plugin add svn https://github.com/cpritchett/asdf-svn.git
```

svn:

```shell
# Show all installable versions
asdf list-all svn

# Install specific version
asdf install svn latest

# Set a version globally (on your ~/.tool-versions file)
asdf global svn latest

# Now svn commands are available
svn --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Extension Commands

This plugin provides additional SVN-specific commands that extend asdf's functionality:

```shell
# Show SVN repository information for the current directory or specified path
asdf svn repo-info [path]
# [path] is optional. If not provided, the command defaults to the current directory.

# Clean up an SVN working copy that may be in an inconsistent state
asdf svn clean [path]
# [path] is optional. If not provided, the command defaults to the current directory.
```

For standard version management, use the built-in asdf commands:
- `asdf list-all svn` - List all available SVN versions
- `asdf list svn` - List installed SVN versions
- `asdf current svn` - Show current SVN version
- `asdf where svn` - Show installation path

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/cpritchett/asdf-svn/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Chad Pritchett](https://github.com/cpritchett/)
