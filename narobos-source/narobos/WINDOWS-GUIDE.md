# NarobOS — Windows Build Guide

Follow these steps exactly and you'll have a bootable NarobOS ISO.
Total time: ~1 hour (most of it waiting).

---

## Step 1 — Install VirtualBox

1. Go to https://www.virtualbox.org/wiki/Downloads
2. Click **Windows hosts**
3. Run the installer, accept all defaults
4. Reboot if it asks you to

---

## Step 2 — Install Vagrant

1. Go to https://developer.hashicorp.com/vagrant/downloads
2. Click **Windows** → **AMD64**
3. Run the installer, accept all defaults
4. **Reboot your PC** (Vagrant requires this)

---

## Step 3 — Extract NarobOS

1. Extract `narobos-source.tar.gz` to somewhere simple like `C:\narobos`
2. Make sure the folder contains `Vagrantfile` and `build.sh`

---

## Step 4 — Start the build VM

Double-click `START-BUILD.bat`

Or manually in Command Prompt:
```
cd C:\narobos
vagrant up
vagrant ssh
```

**First run only:** Vagrant downloads an Ubuntu VM image (~500MB).
This takes a few minutes — normal.

---

## Step 5 — Build the ISO

Once you're inside the VM (you'll see `vagrant@narobos-builder:~$`):

```bash
cd /narobos
./build.sh
```

Then wait. The build downloads and compiles everything.
**Do not close the window.** It takes 30–60 minutes.

You'll see a progress log streaming past — that's normal.

---

## Step 6 — Get your ISO

When it finishes you'll see:

```
Build complete!
  ISO: narobos-1.0-amd64.iso (1.8G)
```

The ISO appears in `C:\narobos\` on your Windows machine
(the folder is shared into the VM automatically).

---

## Step 7 — Flash to USB

Use **Balena Etcher** (free, easiest):
1. Download from https://etcher.balena.io
2. Select your `narobos-1.0-amd64.iso`
3. Select your USB drive (8GB+)
4. Click Flash

---

## Shutting down the VM

When you're done building:
```bash
exit          # leave the VM
vagrant halt  # shut it down
```

To delete the VM entirely (frees ~8GB):
```
vagrant destroy
```

---

## Troubleshooting

**"VT-x is not available" error**
→ Enable virtualisation in your PC's BIOS/UEFI settings.
  Look for "Intel VT-x", "AMD-V", or "SVM" and enable it.

**Build fails partway through**
→ Run `./build.sh clean` inside the VM to start fresh.
→ Check `build.log` for the exact error.

**"Vagrant was unable to mount VirtualBox shared folders"**
→ Run: `vagrant plugin install vagrant-vbguest`
→ Then: `vagrant reload --provision`

**VM is very slow**
→ Open VirtualBox, go to Settings → System
→ Increase RAM to 8192MB and CPUs to 6 if your PC allows it
