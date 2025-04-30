#!/usr/bin/env bash

set -euo pipefail

# Apache Subversion official website and repository
GH_REPO="https://subversion.apache.org/"
TOOL_NAME="svn"
# shellcheck disable=SC2034 # This variable may be used by scripts that source this file
TOOL_TEST="svn --version"

fail() {
    echo -e "asdf-$TOOL_NAME: $*"
    exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if svn is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
    curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
        LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
    git ls-remote --tags --refs "$GH_REPO" |
        grep -o 'refs/tags/.*' | cut -d/ -f3- |
        grep '^[0-9]' | # Filter for version tags that start with numbers
        sed 's/^v//'    # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
    # Instead of using GitHub tags, fetch versions from Apache archive
    # Similar to how Homebrew lists available versions
    local versions_url="https://archive.apache.org/dist/subversion/"
    curl -s "$versions_url" |
        grep -o 'subversion-[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.bz2' |
        sed 's/subversion-//g' |
        sed 's/\.tar\.bz2//g' |
        sort_versions
}

download_release() {
    local version filename url
    version="$1"
    filename="$2"

    # Apache SVN uses .tar.bz2 format on their archive site
    url="https://archive.apache.org/dist/subversion/subversion-${version}.tar.bz2"

    echo "* Downloading $TOOL_NAME release $version..."
    curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="$3"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    # The actual installation is handled in the bin/install script
    # This function is preserved for compatibility with asdf
    echo "Installing $TOOL_NAME $version to $install_path"

}
