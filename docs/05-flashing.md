# Custom OS Flashing Guide

## Prerequisites — ALL Methods

1. ✅ **Backup stock firmware** (see [Firmware Backup Guide](02-firmware-backup.md))
2. ✅ **Backup radio partitions** (modem, fsg, modemst1/2 — contains IMEI!)
3. ✅ **Download the flash tool**: [bkerler/edl](https://github.com/bkerler/edl)
4. ✅ **Know how to enter EDL mode** (see [USB Modes](04-usb-modes.md))

### Bootloader Warning

**After flashing lk1st/lk2nd, the device will NO LONGER boot stock Android.** This is normal — the device is now ready for custom Linux. Ensure you have a full stock backup before proceeding.

## Option A: OpenWrt (Recommended — Most Mature)

**Repository:** [hkfuertes/msm8916-openwrt](https://github.com/hkfuertes/msm8916-openwrt)
**Kernel:** 6.12+
**Best for:** Router, VPN, firewall, USB gadget

### Features
- ✅ Modem (LTE) working
- ✅ WiFi working
- ✅ USB gadget modes (RNDIS, NCM, HID, serial)
- ✅ Tailscale, WireGuard, LuCI web interface
- ✅ ModemManager with QMI

### Flashing
```bash
# Download latest release
wget https://github.com/hkfuertes/msm8916-openwrt/releases/latest/download/openwrt-msm89xx-msm8916-uz801.tar.xz
tar xf openwrt-msm89xx-msm8916-uz801.tar.xz

# Enter EDL mode
# Run flash script (auto-backsup radio partitions!)
cd OpenWRT-UZ801
./flash.sh   # Linux
# OR flash.bat  # Windows

# After flashing:
# - Access: http://192.168.1.1 (LuCI)
# - SSH: root@192.168.1.1
```

## Option B: Debian Linux

**Resources:** [OpenStick](https://github.com/OpenStick/OpenStick) | [Wim van 't Hoog](https://wvthoog.nl/openstick/)
**Kernel:** 6.7+
**Best for:** General purpose, pentesting, services

### Features
- ✅ Full Debian apt repository
- ✅ ModemManager + LTE
- ✅ USB gadget
- ✅ WiFi client
- ✅ Docker support

### Flashing
```bash
# Download image
wget https://download.wvthoog.nl/openstick-uz801-v3.0.zip
unzip openstick-uz801-v3.0.zip

# Enter fastboot
adb reboot bootloader
# OR enter fastboot via button hold

# Flash
./flash.sh   # Linux
# OR flash.bat  # Windows
```

## Option C: Alpine Linux

**Repository:** [hkfuertes/msm8916-alpine](https://github.com/hkfuertes/msm8916-alpine)
**Kernel:** 6.12+ (via pmOS)
**Best for:** Docker, lightweight services, OctoPrint

### Features
- ✅ Alpine Linux v3.21 with pmOS kernel
- ✅ Pre-built profiles: `default`, `docker`, `zoraxy`, `octoprint`
- ✅ USB gadget (NCM/RNDIS)
- ✅ ModemManager + QMI
- ✅ Zoraxy reverse proxy
- ✅ WireGuard

### Building & Flashing
```bash
git clone https://github.com/hkfuertes/msm8916-alpine.git
cd msm8916-alpine

# Configure
cp variables.env.example variables.env
# Edit: set PASSWORD, WIFI_SSID/WIFI_PASS (optional)

# Build (inside Vagrant VM)
make docker   # or: make octoprint / make zoraxy

# Or build directly:
make build-all-vm

# Flash via EDL
./flash.sh
```

## Option D: postmarketOS

**Wiki:** [Zhihe series LTE dongles](https://wiki.postmarketos.org/wiki/Zhihe_series_LTE_dongles_(generic-zhihe))
**Kernel:** Mainline
**Best for:** Mobile Linux, Wayland/GNOME

### Features
- ✅ Mainline Linux kernel
- ✅ Wayland support (weston)
- ✅ ModemManager
- ✅ Full pmOS ecosystem

### Flashing
```bash
# Install pmbootstrap
pip install pmbootstrap

# Initialize
pmbootstrap init
# Vendor: qcom
# Device: zhihe-generic
# User interface: console

# Build & flash
pmbootstrap install
pmbootstrap flasher flash_rootfs
pmbootstrap flasher flash_kernel
```

## Option E: Yocto Linux (U4GO)

**Guide:** [U4GO Open USB 4G](https://blog.iohub.dev/u4go-open-usb-4g/)
**Best for:** Ultra-minimal custom builds

## Bootloader: lk1st/lk2nd (Required for Custom OS)

All custom Linux options require replacing the stock Android bootloader:

```bash
# Build lk2nd with UZ801 device tree
git clone https://github.com/msm8916-mainline/lk2nd.git
cd lk2nd
make LK2ND_BUNDLE_DTB="msm8916-512mb-mtp.dtb" \
     LK2ND_COMPATIBLE="yiming,uz801-v3" \
     TOOLCHAIN_PREFIX=arm-none-eabi- lk1st-msm8916

# Sign with qhypstub
../qhypstub/qtestsign/qtestsign.py aboot build-lk1st-msm8916/emmc_appsboot.mbn

# Enter fastboot and flash
fastboot flash aboot emmc_appsboot-test-signed.mbn
fastboot flash tz tz.mbn
fastboot flash hyp qhypstub-test-signed.mbn
fastboot flash sbl1 sbl1.mbn  # Required for UZ801!
```

## Post-Flash Configuration

### LTE Modem Setup
```bash
# Modem firmware files (from stock backup) must be in /lib/firmware/
# Required: modem.*, mba.mbn, mcfg_sw.mbn

# Check modem
mmcli -m 0

# Set APN
mmcli -m 0 --3gpp-set-initial-eps-bearer-settings=apn=internet

# Connect
nmcli connection add type gsm ifname cdc-wdm0 con-name lte apn internet
nmcli connection up lte
```

### USB Gadget Modes
```bash
# Check current mode
cat /sys/kernel/config/usb_gadget/g1/UDC

# OpenWrt: LuCI → Services → USB Gadget
# Alpine: usb-gadget enable_ncm / enable_rndis
# Debian: manual configfs setup
```
