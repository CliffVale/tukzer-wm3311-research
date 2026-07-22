# Firmware Backup

The full firmware backup (20 partitions, ~948MB) is available as a **GitHub Release** asset:

👉 **[Download firmware backup from Releases](https://github.com/CliffVale/tukzer-wm3311-research/releases)**

## Included partitions

| File | Size | Description |
|------|------|-------------|
| sbl1.bin | 512KB | Secondary Boot Loader (ELF) |
| aboot.bin | 1MB | Android Bootloader |
| rpm.bin | 512KB | Resource Power Manager |
| tz.bin | 512KB | TrustZone |
| hyp.bin | 512KB | Hypervisor |
| modem.bin | 64MB | Modem firmware (FAT16) |
| boot.bin | 16MB | Android boot image (ANDROID!) |
| recovery.bin | 16MB | Recovery image |
| system.bin | 800MB | System partition (ext4) |
| persist.bin | 32MB | Persistent data |
| splash.bin | 10MB | Boot splash (SPLASH!!) |
| fsg.bin | 1.5MB | Modem filesystem |
| modemst1.bin | 1.5MB | Modem state 1 |
| modemst2.bin | 1.5MB | Modem state 2 |
| misc.bin | 1MB | Miscellaneous |
| pad.bin | 1MB | Padding |
| fsc.bin | 1KB | Filesystem cookie |
| sec.bin | 16KB | Security |
| ssd.bin | 8KB | SSD |
| DDR.bin | 32KB | DDR training data |

## Checksums

See `md5sums.txt` in this directory.

## How to reproduce

```bash
git clone https://github.com/CliffVale/tukzer-wm3311-research.git
cd tukzer-wm3311-research
./scripts/backup-firmware.sh
```

## ⚠️ Important

- These dumps are from **device SN 10210203393, IMEI 866755026828238**
- **Do NOT flash the modem partitions from this backup** to another device — you will change its IMEI
- Only use the modem partitions to **restore this specific device**
- The system partition contains your device-specific settings
