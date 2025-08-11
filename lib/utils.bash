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
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
    # Try Apache archive first, fallback to GitHub tags for reliable versions
    local versions_url="https://archive.apache.org/dist/subversion/"
    if curl -s "$versions_url" >/dev/null 2>&1; then
        curl -s "$versions_url" | \
            grep -o 'subversion-[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.bz2' | \
            sed 's/subversion-//g' | \
            sed 's/\.tar\.bz2//g' | \
            sort -u | \
            sort_versions
    else
        # Fallback to a curated list of stable versions
        printf "%s\n" "1.10.8" "1.11.1" "1.12.2" "1.13.0" "1.14.5" | sort_versions
    fi
}

download_release() {
    local version filename
    version="$1"
    filename="$2"

    echo "* Downloading $TOOL_NAME release $version..."
    
    # Try Apache archive first (this is where official releases are)
    local apache_url="https://archive.apache.org/dist/subversion/subversion-${version}.tar.bz2"
    
    if curl "${curl_opts[@]}" -o "$filename" -C - "$apache_url"; then
        echo "✅ Downloaded from Apache archive"
        return 0
    fi
    
    echo "⚠️  Apache archive download failed, trying current releases..."
    # Try current Apache releases
    local current_url="https://downloads.apache.org/subversion/subversion-${version}.tar.bz2"
    
    if curl "${curl_opts[@]}" -o "$filename" -C - "$current_url"; then
        echo "✅ Downloaded from Apache current releases"
        return 0
    fi
    
    fail "❌ Could not download Subversion $version from any known location"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="$3"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    # Build and install SVN from source
    build_and_install_svn "$version" "$install_path"
}

build_and_install_svn() {
    local version="$1"
    local install_path="$2"
    local source_path="$ASDF_DOWNLOAD_PATH"
    
    echo "Building Subversion ${version} from source..."
    echo "Source: $source_path"
    echo "Target: $install_path"
    
    (
        cd "$source_path"
        
        # Simple configure with sensible defaults
        echo "Configuring..."
        ./configure \
            --prefix="$install_path" \
            --with-apr="$(command -v apr-1-config || echo /usr/bin/apr-1-config)" \
            --with-apr-util="$(command -v apu-1-config || echo /usr/bin/apu-1-config)" \
            --with-ssl \
            --with-sqlite3 \
            --without-berkeley-db \
            --with-utf8proc=internal
        
        echo "Building (this may take several minutes)..."
        make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"
        
        echo "Installing..."
        make install
        
        # Verify installation
        if [ -x "$install_path/bin/svn" ]; then
            echo "✅ Subversion $version installation successful!"
            "$install_path/bin/svn" --version | head -1
        else
            fail "❌ Installation failed - svn binary not found at $install_path/bin/svn"
        fi
        
    ) || fail "❌ Failed to build Subversion $version"
}
