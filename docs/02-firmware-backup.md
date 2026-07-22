# Firmware Backup Guide

Two methods to backup the stock firmware. **Method A** (HTTP) is recommended — no tools needed beyond `curl`.

## Method A: HTTP Backup via Web Filesystem (Recommended)

**No ADB or EDL required!** The stock firmware's Webkey web framework exposes the entire filesystem including raw block devices via HTTP.

### Prerequisites
- Device in RNDIS mode (USB connected, web UI accessible)
- `curl` installed on host

### Step 1: Verify Connectivity

```bash
# Test web UI access
curl --digest -u admin:admin http://192.168.42.129/ -o /dev/null -w "%{http_code}"
# Should return: 200

# Test filesystem access
curl --digest -u admin:admin http://192.168.42.129/files/proc/partitions
```

### Step 2: Download Partitions

```bash
# Create backup directory
mkdir -p firmware-backup
cd firmware-backup

# Backup each partition by name
for name in sbl1 aboot rpm tz hyp fsc fsg modemst1 modemst2 sec misc DDR splash ssd pad modem boot recovery persist system; do
  curl --digest -u admin:admin \
    -o "${name}.bin" \
    "http://192.168.42.129/files/dev/block/bootdevice/by-name/${name}"
done

# Verify
ls -lh
md5sum *.bin > md5sums.txt
```

### Step 3: Verify Partition Integrity

```bash
# Check boot image header
xxd -l 16 boot.bin
# Should show: ANDROID!

# Check splash
xxd -l 16 splash.bin
# Should show: SPLASH!!

# Check ext4 superblock (system)
xxd -s 1024 -l 8 system.bin
# Should show valid ext4 superblock magic (0xEF53) at offset 1080
```

### Alternative: Use the Script

Clone this repo and run:
```bash
./scripts/backup-firmware.sh
```

## Method B: EDL Backup (Traditional)

Use when HTTP method is not available or for full raw eMMC dump.

### Prerequisites
- [bkerler/edl](https://github.com/bkerler/edl) tool installed
- USB cable
- Tweezers or wire for shorting EDL pins

### Step 1: Enter EDL Mode

**Option 1 — Hardware short (always works):**
1. Power off device
2. Short D+ and GND pins on USB connector
3. Plug into computer while holding short
4. Release after ~2 seconds
5. Device shows as `05c6:9008` (Qualcomm QD Loader)

**Option 2 — ADB (if ADB is available):**
```bash
adb reboot edl
```

**Option 3 — Fastboot (if bootloader is accessible):**
```bash
adb reboot bootloader
fastboot oem reboot-edl
```

### Step 2: Full Firmware Dump

```bash
# Full eMMC dump (~2GB)
edl rf stock-firmware-full.bin

# Or partition-level backup
edl rl stock-partitions --genxml
```

### Step 3: Restore (if needed)

```bash
# Full restore
edl wf stock-firmware-full.bin

# Partition-level
edl wl stock-partitions/
```

## ⚠️ Critical: Radio Partitions

These partitions contain your **IMEI** and modem calibration data. Back them up separately and **never flash someone else's**:

```bash
for part in modem modemst1 modemst2 fsg fsc persist sec; do
  curl --digest -u admin:admin \
    -o "${part}.bin" \
    "http://192.168.42.129/files/dev/block/bootdevice/by-name/${part}"
done
```

### IMEI Recovery (if lost)
```bash
modem_at AT+WRIMEI=<YOUR_IMEI>
```

## Backup Verification Checklist

- [ ] boot.bin starts with `ANDROID!` header
- [ ] splash.bin starts with `SPLASH!!` header
- [ ] sbl1.bin starts with `\x7fELF` (ELF binary)
- [ ] modem.bin starts with `MSDOS5.0` (FAT16 filesystem)
- [ ] system.bin has ext4 superblock at offset 1024
- [ ] All MD5 checksums recorded
- [ ] Radio partitions backed up separately
