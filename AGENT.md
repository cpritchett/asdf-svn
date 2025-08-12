# AGENT.md

This is a configuration file for AI coding assistants following the [AGENT.md specification](https://ampcode.com/AGENT.md).

## Project Overview

This is an asdf plugin for managing Apache Subversion (SVN) installations. The plugin allows users to install and manage different versions of SVN through the asdf version manager.

**Architecture**: 
- **Pragmatic approach**: Recommend system package managers for most users
- **Source building**: Only for advanced users who set `ASDF_SVN_BUILD_FROM_SOURCE=true`
- **CI exception**: Automatically enable source building in GitHub Actions environment

## Development Workflow

**IMPORTANT**: Always use feature branches and pull requests for changes to this repository.

### Required Process:
1. **Create feature branch**: `git checkout -b feature/description` or `git checkout -b fix/description`
2. **Make changes**: Edit files as needed
3. **Commit changes**: Use conventional commit messages
4. **Push branch**: `git push -u origin branch-name`
5. **Create PR**: Use `gh pr create` with detailed description
6. **Wait for review**: Do not merge directly to main

### Never:
- Commit directly to main branch
- Push changes without creating a PR first
- Merge without review (even if you have permissions)

### Commit Message Format:
```
type: short description

- Detailed explanation of changes
- Use bullet points for multiple changes
- Include context about why the change was needed

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Build Commands

### Initial Setup
```bash
# Install asdf version manager
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
export PATH="$HOME/.asdf/bin:$PATH"
source $HOME/.asdf/asdf.sh
```

### Testing
```bash
# Basic plugin functionality test (no dependencies required)
./scripts/test.bash

# Test individual components
bash bin/list-all | wc -w  # Should return ~298 versions
bash bin/latest-stable     # Get latest stable version
bash bin/download          # Test download functionality

# Test plugin locally (requires build dependencies)
asdf plugin test svn $(pwd) "svn --version"

# Full test with SVN installation (requires build dependencies)
ASDF_SVN_BUILD_FROM_SOURCE=true asdf plugin test svn https://github.com/cpritchett/asdf-svn.git "svn --version"

# Test locally with environment variables
ASDF_SVN_BUILD_FROM_SOURCE=true asdf install svn latest
ASDF_SVN_SKIP_DEPS_CHECK=true # Skip dependency validation in CI
```

### Dependencies
- **Runtime**: `bash`, `curl`, `tar`, and POSIX utilities
- **Build tools** (for source building): `autoconf`, `automake`, `libtool`, `gcc`, `make`, `pkg-config`
- **Libraries** (for source building): `apr`, `apr-util`, `openssl`, `sqlite3`

### Installation Commands
```bash
# Ubuntu/Debian build dependencies
sudo apt-get install build-essential autoconf automake libtool pkg-config libssl-dev libsqlite3-dev libapr1-dev libaprutil1-dev

# macOS build dependencies  
brew install apr apr-util autoconf automake libtool pkg-config openssl sqlite
```

## Code Style

- Follow bash best practices and use `set -euo pipefail`
- Use meaningful variable names and comments for complex logic
- Maintain compatibility with POSIX shell where possible
- Follow existing patterns in the asdf plugin ecosystem

## Architecture

### Repository Structure
```
.
├── .github/
│   └── workflows/          # CI/CD pipelines
│       ├── build.yml       # Plugin testing on Ubuntu/macOS
│       └── release.yml     # Release automation
├── bin/                   # Plugin executable scripts
│   ├── download           # Download SVN source
│   ├── install           # Install SVN from download
│   ├── latest-stable     # Get latest stable version
│   └── list-all          # List all available versions
├── lib/
│   └── utils.bash        # Shared utility functions
├── scripts/
│   ├── check-deps.bash   # Dependency validation
│   └── test.bash         # Local testing script
├── .editorconfig         # Code style configuration
├── .tool-versions        # Required tool versions (currently empty)
├── renovate.json         # Automated dependency updates
├── contributing.md       # Development guide
└── README.md            # Usage instructions
```

### Key Components:
- `bin/download` - Downloads SVN source from Apache repositories
- `bin/install` - Compiles and installs SVN from downloaded source
- `bin/list-all` - Lists available SVN versions from Apache git tags
- `bin/latest-stable` - Determines latest stable release
- `lib/utils.bash` - Contains shared functions for download/install logic
- `scripts/check-deps.bash` - Dependency validation
- `scripts/test.bash` - Local testing script

### Environment Variables:
- `ASDF_SVN_BUILD_FROM_SOURCE=true` - Enable source building (advanced users)
- `ASDF_SVN_SKIP_DEPS_CHECK=true` - Skip dependency validation (CI environments)

## Testing

### Local Testing:
- Use `ASDF_SVN_BUILD_FROM_SOURCE=true` when testing locally
- CI automatically enables source building
- Set `ASDF_SVN_SKIP_DEPS_CHECK=true` to skip dependency validation in CI

### Test Strategy:
1. **Basic functionality**: Test version listing and plugin loading without dependencies
2. **Full integration**: Test actual SVN installation with build dependencies
3. **CI validation**: Automated testing in GitHub Actions

### Known Issues:
- **Apache SVN Distribution**: Plugin currently has URL issues with Apache SVN distributions
- **Current workaround**: Plugin downloads from GitHub archive instead of official Apache distributions
- **Impact**: `asdf plugin test` may fail, but individual bin scripts work correctly
- **Status**: Plugin successfully lists ~298 versions from Apache git repository

### Timing Expectations:
- Fresh asdf setup: 1-2 minutes (NEVER CANCEL - set 5+ minute timeout)
- Plugin test (`asdf plugin test`): 2-3 seconds (currently may fail due to Apache SVN URL issues)
- Individual script tests: <1 second each

## Security

- No secrets or API keys required
- Downloads from official Apache SVN releases
- Validates checksums when available
- Uses secure HTTPS URLs for downloads

## Documentation

### Key Files:
- `README.md` - User-facing documentation with installation instructions
- `contributing.md` - Developer contribution guidelines
- `docs/installation.md` - Detailed installation documentation

### Documentation Guidelines:
- README should clearly explain system package manager recommendation
- Include build-from-source instructions for advanced users  
- Keep contributing guide up-to-date with correct test commands
- Maintain clear separation between user and developer documentation

### CI/CD Pipeline:
- **Build workflow**: Tests plugin on Ubuntu and macOS (may fail due to URL issues)
- **Release workflow**: Automated releases via release-please
- **Dependency management**: Uses Renovate for automated updates only