#!/bin/bash
# NarobOS — main build script
# Usage: ./build.sh [clean]
set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}"
echo "  _   _                 _      ___  ____  "
echo " | \\ | | __ _ _ __ ___ | |__  / _ \\/ ___| "
echo " |  \\| |/ _\` | '__/ _ \\| '_ \\| | | \\___ \\ "
echo " | |\\  | (_| | | | (_) | |_) | |_| |___) |"
echo " |_| \\_|\\__,_|_|  \\___/|_.__/ \\___/|____/ "
echo ""
echo -e "${RESET}${BOLD} Building NarobOS 1.0 — Gaming Linux Distro${RESET}"
echo ""

# Check dependencies
echo -e "${CYAN}[1/5] Checking build dependencies...${RESET}"
for dep in lb debootstrap curl gpg; do
    if ! command -v "$dep" &>/dev/null; then
        echo -e "${RED}Missing: $dep${RESET}"
        echo "Install with: sudo apt-get install live-build debootstrap curl gnupg"
        exit 1
    fi
done
echo -e "${GREEN}All dependencies found.${RESET}"

# Clean previous build if requested
if [ "$1" = "clean" ]; then
    echo -e "${CYAN}[2/5] Cleaning previous build...${RESET}"
    sudo lb clean --purge
else
    echo -e "${CYAN}[2/5] Skipping clean (run './build.sh clean' to start fresh)${RESET}"
fi

# Make hooks executable
chmod +x auto/hooks/live/*.hook.chroot 2>/dev/null || true

# Run live-build config
echo -e "${CYAN}[3/5] Configuring live-build...${RESET}"
sudo bash auto/config

# Copy package lists into live-build expected location
echo -e "${CYAN}[4/5] Setting up package lists...${RESET}"
mkdir -p config/package-lists
cp auto/packages/*.list.chroot config/package-lists/

# Build the ISO
echo -e "${CYAN}[5/5] Building ISO (this will take 20–60 minutes)...${RESET}"
echo "      Go grab a coffee. Seriously."
echo ""
sudo lb build 2>&1 | tee build.log

# Check output
if ls *.iso 1>/dev/null 2>&1; then
    ISO=$(ls *.iso | head -1)
    SIZE=$(du -sh "$ISO" | cut -f1)
    echo ""
    echo -e "${GREEN}${BOLD}Build complete!${RESET}"
    echo -e "  ISO: ${BOLD}$ISO${RESET} (${SIZE})"
    echo ""
    echo "  Flash to USB:"
    echo -e "  ${BOLD}sudo dd if=$ISO of=/dev/sdX bs=4M status=progress oflag=sync${RESET}"
    echo "  (replace /dev/sdX with your USB drive)"
else
    echo -e "${RED}Build failed — check build.log for details${RESET}"
    exit 1
fi
