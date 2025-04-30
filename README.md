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

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

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

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/cpritchett/asdf-svn/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Chad Pritchett](https://github.com/cpritchett/)
