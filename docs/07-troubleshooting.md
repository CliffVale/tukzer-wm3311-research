# Troubleshooting & Recovery

## Device Won't Boot

### Symptoms
- No LEDs
- Solid red LED
- USB not detected

### Recovery Steps
```bash
# 1. Check USB power (minimum 5V/1A adapter)
# 2. Try different USB cable and port
# 3. Hold power button 10s for force reset
# 4. Try EDL mode via hardware short

# 5. If EDL works, restore firmware:
edl wf stock-firmware-full.bin

# 6. If EDL doesn't work, check UART console
# (requires soldering, 1.8V level shifter)
```

## IMEI Lost

### Symptoms
- Modem shows IMEI as "0" or "004999010640000"
- Can't register on network

### Recovery
```bash
# Option 1: Restore modemst1/modemst2 from backup
edl w modemst1 modemst1.bin
edl w modemst2 modemst2.bin

# Option 2: Write IMEI directly (use YOUR original IMEI only!)
mmcli -m 0 --command='AT+WRIMEI=<YOUR_IMEI>'
# OR
modem_at AT+WRIMEI=<YOUR_IMEI>
```

## Device Stuck in Fastboot

### Symptoms
- LED: varies
- USB: `18d1:d00d` (fastboot)
- `fastboot reboot` doesn't boot Android

### Solutions
```bash
# 1. Try to continue boot
fastboot continue

# 2. Try oem commands
fastboot oem reboot-edl

# 3. Power cycle: hold power 10s, unplug USB, try again

# 4. If boot partition is corrupt, flash new boot
fastboot flash boot new-boot.img

# 5. Last resort: EDL hardware short → restore full backup
```

## Web UI Not Accessible

### Symptoms
- Can't reach 192.168.42.129 (RNDIS) or 192.168.43.1 (WiFi)
- Curl returns connection refused or timeout

### Solutions
```bash
# 1. Check USB mode
lsusb | grep 05c6

# 2. If 05c6:f006 (HID): press power button briefly
# 3. If 18d1:d00d (fastboot): power cycle and try again
# 4. If 05c6:9008 (EDL): device is in flash mode, no web UI

# 5. Check RNDIS interface
ip addr show | grep 192.168.42

# 6. Check if web server is running on device
# (via ADB if available)
adb shell ps | grep mongoose
```

## ADB Not Working

### Symptoms
- `adb devices` shows empty
- Backdoor URL returns 404

### Solutions
```bash
# 1. The USB gadget is RNDIS-only by default
#    ADB function is not loaded:
cat /sys/class/android_usb/android0/functions
# Returns: rndis

# 2. Try different backdoor URLs:
curl http://192.168.100.1/usbdebug.html
curl http://192.168.42.129/usbdebug.html

# 3. Alternative: Use HTTP filesystem instead
#    Full access without ADB at:
curl --digest -u admin:admin http://192.168.42.129/files/

# 4. Use ShellInABox terminal (if available)
#    http://192.168.42.129/terminal.html

# 5. Last resort: EDL mode for full backup
```

## Overheating

### Symptoms
- Device gets very hot to touch
- Random shutdowns or throttling

### Solutions
```bash
# 1. Stock firmware only enables 2 of 4 CPU cores
#    to prevent overheating — this is intentional

# 2. If running custom OS, monitor temperature:
cat /sys/class/thermal/thermal_zone*/temp

# 3. Add heatsink to SoC
# 4. Ensure adequate ventilation
# 5. Reduce CPU frequency if needed
# 6. Don't charge and use LTE simultaneously for long periods
```

## Slow WiFi on Custom OS

OpenWrt WiFi is slower than stock — known driver optimization issue. Monitor for improvements in kernel updates.

## Can't Flash (EDL Not Detected)

```bash
# 1. Check USB cable quality
# 2. Try USB 2.0 port (not USB 3.0)
# 3. Ensure the short is correct (D+ to GND, not VCC)
# 4. On Linux: modprobe usbserial
# 5. Try different EDL tool version
# 6. Check dmesg for USB errors
```

## Known Limitations

1. **2GB eMMC** — limited space for multi-use deployments (~3.2GB usable after custom OS with larger partition table)
2. **512MB RAM** — tight for Docker + multiple containers; use Alpine for best efficiency
3. **No ADB by default** — USB gadget configured as RNDIS-only in stock firmware
4. **WiFi slower on OpenWrt** — driver optimization pending
5. **1.8V UART** — will damage board if 3.3V/5V adapter is connected directly
6. **Only 2 cores active in stock** — other 2 disabled to prevent overheating
