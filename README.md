<div align="center">

# asdf-svn [![Build](https://github.com/cpritchett/asdf-svn/actions/workflows/build.yml/badge.svg)](https://github.com/cpritchett/asdf-svn/actions/workflows/build.yml) [![Lint](https://github.com/cpritchett/asdf-svn/actions/workflows/lint.yml/badge.svg)](https://github.com/cpritchett/asdf-svn/actions/workflows/lint.yml)

[svn](https://svnbook.red-bean.com/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)

**For most users**: We recommend installing SVN via your system package manager:
- **Ubuntu/Debian**: `sudo apt-get install subversion`  
- **macOS**: `brew install subversion`
- **RHEL/CentOS**: `dnf install subversion`

**For building from source** (advanced users), additional dependencies required:
- Build tools: `autoconf`, `automake`, `libtool`, `gcc`, `make`, `pkg-config`
- Libraries: `apr`, `apr-util`, `openssl`, `sqlite3`
- Set `export ASDF_SVN_BUILD_FROM_SOURCE=true` before installation

# Install

Plugin:

```shell
asdf plugin add svn
# or
asdf plugin add svn https://github.com/cpritchett/asdf-svn.git
```

SVN versions:

```shell
# Show all installable versions
asdf list-all svn

# Install specific version (requires ASDF_SVN_BUILD_FROM_SOURCE=true)
export ASDF_SVN_BUILD_FROM_SOURCE=true
asdf install svn latest

# Set a version globally (on your ~/.tool-versions file)
asdf global svn latest

# Now svn commands are available
svn --version
```

**Note**: This plugin builds SVN from source by default, which requires many dependencies and can take significant time. For most users, we recommend using your system package manager instead (see Dependencies section above).

**Version Updates**: This plugin maintains a curated list of stable SVN versions. If you need a newer version that's not listed, please open an issue or PR to update the version list.

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/cpritchett/asdf-svn/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Chad Pritchett](https://github.com/cpritchett/)
