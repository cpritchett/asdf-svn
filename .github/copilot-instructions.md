# asdf-svn

ASDF plugin for managing Apache Subversion (SVN) installations. This plugin provides automated installation and version management of SVN through the asdf version manager.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Initial Setup
- Install asdf version manager:
  - `git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1`
  - `export PATH="$HOME/.asdf/bin:$PATH"`
  - `source $HOME/.asdf/asdf.sh`
- Install required plugins and tools:
  - `asdf plugin-add shellcheck https://github.com/luizm/asdf-shellcheck.git`
  - `asdf plugin-add shfmt https://github.com/luizm/asdf-shfmt.git`
  - `asdf install` -- takes 2 seconds to 2 minutes depending on cache. NEVER CANCEL. Set timeout to 5+ minutes.

### Development Workflow
- Run linting: `scripts/lint.bash` -- takes <1 second. Always run before committing.
- Run formatting: `scripts/format.bash` -- takes <1 second. Always run before committing.
- Both linting and formatting must pass for CI to succeed.

### Testing the Plugin
- Test plugin locally: `asdf plugin test svn $(pwd) "svn --version"`
- **KNOWN ISSUE**: Plugin currently fails due to Apache SVN distribution URL issues.
- **WORKAROUND**: Plugin downloads from GitHub archive instead of official Apache distributions.
- List available versions: `bash bin/list-all` (works correctly)
- Get latest version: `bash bin/latest-stable` (has issues with GitHub releases API)

## Validation

### Complete Developer Workflow Validation
After making any changes, always run through this complete scenario:
1. **Lint and format code**: `scripts/lint.bash && scripts/format.bash`
2. **Test plugin basics**: `bash bin/list-all | wc -w` (should return ~298 versions)
3. **Verify individual components**: Test modified scripts directly (e.g., `bash bin/download`)
4. **Git status check**: `git status` to see what files changed
5. **Commit preparation**: Ensure only intended files are staged

### Before Committing Changes
- Always run both linting and formatting commands:
  - `scripts/lint.bash` (shellcheck + shfmt validation)
  - `scripts/format.bash` (auto-format bash scripts)
- Verify plugin scripts work: test individual bin scripts like `bash bin/list-all`
- CI will fail if linting or formatting issues exist.

### Manual Testing Scenarios
- **Plugin version listing**: `bash bin/list-all` should return hundreds of SVN versions
- **Latest version detection**: `bash bin/latest-stable` (currently has known issues)
- **Download functionality**: Individual bin scripts should execute without syntax errors
- **File integrity**: All bash scripts should pass shellcheck analysis

### Timing Expectations
- Fresh asdf setup: 1-2 minutes (NEVER CANCEL - set 5+ minute timeout)
- Tool installation (`asdf install`): 2 seconds if tools cached, 1-2 minutes if downloading
- Linting (`scripts/lint.bash`): <1 second 
- Formatting (`scripts/format.bash`): <1 second
- Plugin test (`asdf plugin test`): 2-3 seconds (currently fails due to Apache SVN URL issues)

## Common Tasks

### Repository Structure
```
.
├── .github/
│   ├── workflows/          # CI/CD pipelines
│   │   ├── build.yml       # Plugin testing on Ubuntu/macOS
│   │   ├── lint.yml        # Shellcheck + actionlint
│   │   ├── release.yml     # Release automation
│   │   └── semantic-pr.yml # PR title validation
│   └── dependabot.yml     # Dependency updates
├── bin/                   # Plugin executable scripts
│   ├── download           # Download SVN source
│   ├── install           # Install SVN from download
│   ├── latest-stable     # Get latest stable version
│   └── list-all          # List all available versions
├── lib/
│   └── utils.bash        # Shared utility functions
├── scripts/
│   ├── format.bash       # Format bash scripts
│   └── lint.bash         # Lint bash scripts
├── .tool-versions        # Required tool versions
├── contributing.md       # Development guide
└── README.md            # Usage instructions
```

### Key Files to Check When Making Changes
- Always check `lib/utils.bash` when modifying plugin functionality
- Review `.tool-versions` for required tool versions
- Check GitHub workflows in `.github/workflows/` for CI requirements
- Validate changes against `bin/` scripts that implement plugin behavior

### Plugin Architecture
- `bin/download`: Downloads SVN source from Apache repositories
- `bin/install`: Compiles and installs SVN from downloaded source
- `bin/list-all`: Lists available SVN versions from Apache git tags
- `bin/latest-stable`: Determines latest stable release
- `lib/utils.bash`: Contains shared functions for download/install logic

### Dependencies and Tools
- **shellcheck 0.10.0**: Bash script static analysis
- **shfmt 3.11.0**: Bash script formatting
- **asdf**: Version manager framework
- **curl**: For downloading sources and querying APIs
- **tar**: For extracting downloaded archives

### Configuration Files
- `.tool-versions`: Specifies exact versions of shellcheck and shfmt
- `.editorconfig`: Code style configuration (tabs for bash, spaces for YAML/MD)
- `renovate.json`: Automated dependency updates
- `.github/dependabot.yml`: GitHub Actions dependency updates

## Known Issues and Workarounds

### Apache SVN Distribution Issues
- **ISSUE**: Plugin assumes GitHub releases but Apache SVN uses different distribution
- **IMPACT**: `asdf plugin test` and actual installations fail
- **CURRENT STATE**: Plugin needs updates to use correct Apache SVN download URLs
- **WORKAROUND**: Test individual bin scripts directly instead of full plugin test

### Development Notes
- Plugin is a template-based implementation that needs adaptation for Apache SVN
- TODO comments throughout codebase indicate areas needing Apache-specific implementation
- Successfully lists versions from Apache git repository (298+ versions available)
- Download/install logic needs updating for Apache distribution format

### Expected Development Patterns  
- **Fast feedback loop**: Linting and formatting provide immediate feedback (<1 second each)
- **Iterative testing**: Test individual scripts during development rather than full plugin
- **Version management**: Use `bash bin/list-all` to verify version discovery works
- **Error handling**: Most failures occur in download/install due to URL mismatches

### Common Development Tasks
- **Modifying version detection**: Edit `lib/utils.bash` functions `list_github_tags()` and `list_all_versions()`
- **Updating download logic**: Modify `download_release()` function in `lib/utils.bash`
- **Testing changes**: Use `bash bin/[script-name]` to test individual components
- **Debugging**: Add `set -x` to bash scripts for detailed execution tracing

### CI/CD Pipeline
- **Build workflow**: Tests plugin on Ubuntu and macOS (currently fails due to URL issues)
- **Lint workflow**: Runs shellcheck, shfmt, and actionlint (currently passes)
- **Release workflow**: Automated releases via release-please
- **Semantic PR**: Validates conventional commit format in PR titles

Always run `scripts/lint.bash` and `scripts/format.bash` before committing changes to ensure CI passes.