# Tukzer WM3311 / UZ801 — Qualcomm MSM8916 4G LTE Dongle Hacking

**Complete research and firmware recovery for the Tukzer WM3311** — a rebranded UZ801 v3.x 4G LTE WiFi dongle powered by Qualcomm Snapdragon 410 (MSM8916).

## Quick Facts

| Property | Value |
|----------|-------|
| **Device** | Tukzer WM3311 (Turbo U2, TZ-WD-02) |
| **Board** | FY_UZ801_V2.1 / V3.0 / V3.2 |
| **Also known as** | UZ801, UF896, UFI001B/C, UFI003, EFM96301 |
| **SoC** | Qualcomm MSM8916 (Snapdragon 410) — 4× Cortex-A53 @ 1.0-1.2 GHz |
| **RAM** | 512MB LPDDR2/LPDDR3 |
| **Storage** | 2GB eMMC (3,817,472 blocks) |
| **Modem** | Qualcomm MDM9x07 — LTE Cat4 (150/50 Mbps) |
| **WiFi** | 802.11b/g/n 2.4GHz (single-band) |
| **Battery** | 2100mAh Li-Po |
| **Stock OS** | Android 4.4.4 KitKat — build KTU84P (Sep 7, 2021) |
| **ODM** | CHUANGJING (Shenzhen) — model SP971_HW_V2 |
| **Web Framework** | Webkey for Android + SL4A + Mongoose HTTP server |
| **USB** | RNDIS (network gadget) — IP `192.168.42.129` |

## ⚠️ Safety First

**Before attempting any modification:**
1. ✅ **Backup your stock firmware first** — see [Firmware Backup Guide](docs/02-firmware-backup.md)
2. ✅ **Backup radio partitions** separately (modem, fsg, modemst1, modemst2) — IMEI lives there
3. ✅ **Never flash someone else's modem firmware** — you'll lose your IMEI
4. ✅ **Full EDL backup via hardware short** is the universal recovery method

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [01 — Hardware Specs](docs/01-hardware.md) | Full hardware specifications, board revision, pinouts |
| [02 — Firmware Backup](docs/02-firmware-backup.md) | Complete backup guide (HTTP method + EDL method), partition table |
| [03 — Web UI & API](docs/03-web-ui-api.md) | Webkey framework, SL4A JSON-RPC API, filesystem access |
| [04 — USB Modes & Boot States](docs/04-usb-modes.md) | All USB PIDs, LED patterns, EDL/fastboot entry methods |
| [05 — Custom OS Flashing](docs/05-flashing.md) | OpenWrt, Debian, Alpine, postmarketOS, Yocto — full guides |
| [06 — Use Cases](docs/06-use-cases.md) | 37+ use cases from router to pentest to IoT |
| [07 — Troubleshooting](docs/07-troubleshooting.md) | Recovery from brick, IMEI loss, common issues |
| [08 — References](docs/08-references.md) | All GitHub repos, guides, forums, tools |

## 🔧 Quick Start — From Zero to Backup

```bash
# 1. Connect the device via USB (wait for RNDIS mode)
# 2. Access web UI
curl --digest -u admin:admin http://192.168.42.129/

# 3. Verify filesystem access (this is your superpower)
curl --digest -u admin:admin http://192.168.42.129/files/proc/partitions

# 4. Backup critical partitions
./scripts/backup-firmware.sh
```

## 💡 Key Discovery

**The stock firmware's Webkey-for-Android web framework exposes the ENTIRE Linux filesystem via HTTP**, including raw block devices at `/files/dev/block/`. This means:

- **Full firmware backup WITHOUT ADB or EDL** — just `curl` over USB
- **Complete filesystem browsing** from any browser
- **Partition dumping** via simple HTTP GET requests
- **Web terminal** (ShellInABox) for shell access

This is an undocumented attack surface unique to this firmware build.

## 📦 Firmware Backup

Our verified backup (20 partitions, 948MB) is available as a [GitHub Release](https://github.com/CliffVale/tukzer-wm3311-research/releases).

To reproduce the backup yourself:
```bash
git clone https://github.com/CliffVale/tukzer-wm3311-research.git
cd tukzer-wm3311-research
./scripts/backup-firmware.sh
```

## 🎯 Use Cases

This tiny Linux computer with built-in 4G LTE can be:
- OpenWrt travel router with Tailscale/WireGuard
- Debian-based remote pentesting platform (Bettercap, Metasploit)
- Pi-hole/AdGuard DNS sinkhole
- OctoPrint 3D printer controller
- SMS gateway / Telegram bot
- USB Rubber Ducky (HID attack)
- Cloudflare Tunnel / Tor hidden service
- And 30+ more...

## 🛠️ Flashing Custom OS

| OS | Status | Kernel | Best For |
|----|--------|--------|----------|
| **OpenWrt** | ✅ Mature | 6.12+ | Router, VPN, firewall |
| **Debian** | ✅ Stable | 6.7+ | General purpose, pentesting |
| **Alpine** | ✅ Active | 6.12+ | Docker, lightweight services |
| **postmarketOS** | ✅ Supported | Mainline | Mobile Linux, Wayland |
| **Yocto** | ⚠️ Experimental | Custom | Ultra-minimal builds |

See [Flashing Guide](docs/05-flashing.md) for detailed instructions.

## 📝 License

MIT — feel free to use, share, and build upon this research.

## 🙏 Credits

- [AlienWolfX / UZ801-USB_MODEM](https://github.com/iterminatorheart/UZ801-USB_MODEM) — Original research and OpenWrt/Debian guides
- [hkfuertes / msm8916-openwrt](https://github.com/hkfuertes/msm8916-openwrt) — Modern OpenWrt port
- [hkfuertes / msm8916-alpine](https://github.com/hkfuertes/msm8916-alpine) — Alpine Linux with Docker profiles
- [OpenStick](https://github.com/OpenStick/OpenStick) — Original Debian project
- [postmarketOS Wiki](https://wiki.postmarketos.org/wiki/Zhihe_series_LTE_dongles_(generic-zhihe)) — Comprehensive device support
- [Wim van 't Hoog](https://wvthoog.nl/openstick/) — Debian build guide
- [bkerler / edl](https://github.com/bkerler/edl) — Qualcomm EDL tool
- [EFF Rayhunter](https://efforg.github.io/rayhunter/uz801.html) — IMSI catcher detection
- [SensePost P4wnP1-LTE](https://sensepost.com/blog/2023/p4wnp1-lte/) — USB attack platform
