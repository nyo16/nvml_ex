#!/bin/bash
set -e

# Build precompiled NIFs locally and prepare for upload to GitHub releases

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
NATIVE_DIR="$PROJECT_DIR/native/nvml_native"

cd "$PROJECT_DIR"

# Get version from mix.exs
VERSION=$(grep '@version "' mix.exs | sed -e 's/.*@version "//g' -e 's/".*//g')
TARGET="x86_64-unknown-linux-gnu"

echo "Building precompiled NIFs for nvml v$VERSION"
echo "Target: $TARGET"
echo ""

# Create output directory
OUTPUT_DIR="$PROJECT_DIR/precompiled"
mkdir -p "$OUTPUT_DIR"

cd "$NATIVE_DIR"

# Build for each NIF version
for NIF_VERSION in "2.15" "2.16"; do
    echo "Building NIF version $NIF_VERSION..."

    FEATURE="nif_version_${NIF_VERSION//./_}"

    # Clean and build
    cargo build --release --features "$FEATURE"

    # Create tarball
    TARBALL="libnvml_native-v${VERSION}-nif-${NIF_VERSION}-${TARGET}.so.tar.gz"

    # The action expects the .so file to be named libnvml_native.so in the tarball
    tar -czvf "$OUTPUT_DIR/$TARBALL" \
        -C target/release \
        libnvml_native.so

    echo "Created: $OUTPUT_DIR/$TARBALL"
done

echo ""
echo "Done! Files are in: $OUTPUT_DIR"
echo ""
echo "To upload to GitHub release:"
echo "  1. Create a release/tag v$VERSION on GitHub"
echo "  2. Upload the .tar.gz files from $OUTPUT_DIR"
echo ""
echo "Or use gh CLI:"
echo "  gh release create v$VERSION $OUTPUT_DIR/*.tar.gz"
echo ""
echo "After uploading, run:"
echo "  ./bin/checksum.sh"
