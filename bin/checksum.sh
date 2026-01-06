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

echo "Downloading precompiled NIFs and generating checksums..."
echo ""

# Download all precompiled NIFs and print checksums
mix rustler_precompiled.download Nvml.Native --all --print

echo ""
echo -e "${GREEN}Checksums updated!${NC}"
echo ""
echo "Next steps:"
echo "  1. git add checksum-Elixir.Nvml.Native.exs"
echo "  2. git commit -m 'Update checksums for release'"
echo "  3. git push"
echo "  4. mix hex.publish"
