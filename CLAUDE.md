# Claude Code Guidelines

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

## Project-Specific Notes

### SVN Plugin Architecture
- **Pragmatic approach**: Recommend system package managers for most users
- **Source building**: Only for advanced users who set `ASDF_SVN_BUILD_FROM_SOURCE=true`
- **CI exception**: Automatically enable source building in GitHub Actions environment
- **Dependencies**: Complex build requirements (apr, apr-util, openssl, sqlite, build tools)

### Testing
- Use `ASDF_SVN_BUILD_FROM_SOURCE=true` when testing locally
- CI automatically enables source building
- Set `ASDF_SVN_SKIP_DEPS_CHECK=true` to skip dependency validation in CI

### Documentation
- README should clearly explain system package manager recommendation
- Include build-from-source instructions for advanced users
- Keep contributing guide up-to-date with correct test commands