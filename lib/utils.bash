#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for svn.
GH_REPO="https://github.com/apache/subversion"
TOOL_NAME="svn"
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
	local version filename url
	version="$1"
	filename="$2"

	# TODO: Adapt the release URL convention for svn
	url="$GH_REPO/archive/v${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert svn executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
