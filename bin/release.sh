#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

# Functions
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_usage() {
    echo "Usage: $0 <version>"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -s, --skip-tests Skip running tests"
    echo "  -f, --skip-format Skip format checks"
    echo "  --dry-run        Show what would be done without making changes"
    echo ""
    echo "Examples:"
    echo "  $0 0.2.0"
    echo "  $0 0.2.0-beta"
    echo "  $0 0.2.0 --skip-tests"
}

get_current_version() {
    grep '@version "' mix.exs | sed -e 's/.*@version "//g' -e 's/".*//g'
}

validate_version() {
    local version=$1
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?$ ]]; then
        print_error "Invalid version format: $version"
        echo "Version must be in format: X.Y.Z or X.Y.Z-suffix"
        exit 1
    fi
}

update_version() {
    local new_version=$1
    sed -i "s/@version \".*\"/@version \"$new_version\"/" mix.exs
}

# Parse arguments
SKIP_TESTS=false
SKIP_FORMAT=false
DRY_RUN=false
VERSION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_usage
            exit 0
            ;;
        -s|--skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        -f|--skip-format)
            SKIP_FORMAT=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            if [[ -z "$VERSION" ]]; then
                VERSION=$1
            else
                print_error "Unknown argument: $1"
                print_usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate version argument
if [[ -z "$VERSION" ]]; then
    print_error "Version argument is required"
    print_usage
    exit 1
fi

validate_version "$VERSION"

# Get current version
CURRENT_VERSION=$(get_current_version)
echo "Current version: $CURRENT_VERSION"
echo "New version: $VERSION"

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    print_error "There are uncommitted changes. Please commit or stash them first."
    git status --short
    exit 1
fi

# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    print_error "Tag v$VERSION already exists"
    exit 1
fi

# Run format checks
if [[ "$SKIP_FORMAT" != "true" ]]; then
    echo ""
    echo "Checking formatting..."
    mix format --check-formatted
    export PATH="$HOME/.cargo/bin:$PATH"
    cargo fmt --manifest-path native/nvml_native/Cargo.toml --check
    print_success "Format checks passed!"
fi

# Run tests
if [[ "$SKIP_TESTS" != "true" ]]; then
    echo ""
    echo "Running tests..."
    export PATH="$HOME/.cargo/bin:$PATH"
    NVML_BUILD=true mix test
    print_success "Tests passed!"
fi

if [[ "$DRY_RUN" == "true" ]]; then
    echo ""
    print_warning "DRY RUN - Would perform the following:"
    echo "  1. Update version in mix.exs to $VERSION"
    echo "  2. Commit with message: 'Bump version to $VERSION'"
    echo "  3. Create tag v$VERSION"
    echo "  4. Push commit and tag to origin"
    exit 0
fi

# Update version
echo ""
echo "Updating version to $VERSION..."
update_version "$VERSION"

# Commit version bump
git add mix.exs
git commit -m "Bump version to $VERSION"

# Create tag
git tag -a "v$VERSION" -m "Release v$VERSION"

# Push
echo ""
echo "Pushing to origin..."
git push origin HEAD
git push origin "v$VERSION"

print_success ""
print_success "Release v$VERSION created successfully!"
echo ""
echo "Next steps:"
echo "  1. Wait for GitHub Actions to build precompiled NIFs"
echo "  2. Run: ./bin/checksum.sh"
echo "  3. Commit the updated checksums"
echo "  4. Run: mix hex.publish"
