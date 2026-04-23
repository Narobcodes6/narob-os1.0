# NarobOS

A lightweight gaming Linux distro built on Debian Bookworm.
Steam + Proton, Liquorix kernel, Gamescope, MangoHud — nothing else.

---

## What's inside

| Component | Choice | Why |
|---|---|---|
| Base | Debian Bookworm | Stable, wide hardware support |
| Kernel | Liquorix | Low-latency gaming patches |
| Display | Wayland + Gamescope | Valve's gaming compositor, HDR, VRR |
| Gaming | Steam + Proton-GE | Windows games on Linux |
| Overlay | MangoHud | FPS, GPU/CPU temp, frame time |
| Performance | GameMode | Auto CPU/GPU boost when gaming |
| Audio | PipeWire | Low-latency, Steam compatible |

---

## Build requirements

You need a Linux machine (Ubuntu 22.04+ recommended) with:

```bash
sudo apt-get install live-build debootstrap curl gnupg
```

At least **20GB free disk space** and a decent internet connection.
Build time: ~30–60 minutes depending on your machine and connection.

---

## Building the ISO

```bash
git clone <your-repo-url> narobos
cd narobos
chmod +x build.sh
./build.sh
```

To rebuild from scratch:
```bash
./build.sh clean
```

The output will be `narobos-1.0-amd64.iso` in the project root.

---

## Flashing to USB

```bash
# Find your USB drive
lsblk

# Flash (replace /dev/sdX with your drive — double check this!)
sudo dd if=narobos-1.0-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Or use **Balena Etcher** if you prefer a GUI.

---

## Project structure

```
narobos/
├── build.sh                        # Main build script
├── auto/
│   ├── config                      # live-build configuration
│   ├── packages/
│   │   ├── base.list.chroot        # Core system packages
│   │   └── gaming.list.chroot      # Steam, gaming tools
│   └── hooks/live/
│       ├── 0010-add-repos.hook.chroot      # Add Steam/Liquorix repos
│       ├── 0020-kernel-and-proton.hook.chroot  # Install kernel + Proton-GE
│       ├── 0030-gaming-tweaks.hook.chroot  # Performance tuning
│       └── 0040-grub.hook.chroot           # Bootloader config
└── config/
    └── includes.chroot/
        └── etc/narobos/
            └── os-release          # NarobOS identity
```

---

## Recommended Steam launch options

For any game in Steam, right-click → Properties → Launch Options:

**AMD GPU:**
```
RADV_PERFTEST=aco gamemoderun mangohud %command%
```

**Nvidia GPU:**
```
__NV_PRIME_RENDER_OFFLOAD=1 gamemoderun mangohud %command%
```

**Any GPU (baseline):**
```
gamemoderun mangohud %command%
```

---

## Roadmap

- [ ] Custom graphical installer (Calamares)
- [ ] NarobOS game launcher shell (custom UI)
- [ ] Auto-detect GPU and set optimal launch flags
- [ ] OTA update system
- [ ] Nvidia proprietary driver option in installer

---

## License

NarobOS build scripts: MIT
All included software retains its original license.
