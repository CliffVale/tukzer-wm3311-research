# USB Modes & Boot States

## LED Patterns

| LED | Color | State | Meaning |
|-----|-------|-------|---------|
| **Battery** | Green | Solid | Battery charged/charging |
| | Green | Blinking | Battery low |
| | Off | — | Powered off or dead battery |
| **WiFi** | Blue | Solid | WiFi AP active with clients |
| | Blue | Blinking | WiFi AP active, no clients / data |
| | Off | — | WiFi disabled or booting |
| **Network** | Purple | Solid | LTE modem registered on network |
| | Purple | Blinking | LTE data activity |
| | Red | Solid | No SIM or network registration failed |
| | Red | Blinking | Network error / roaming |
| | Off | — | Modem powered down |

## USB Modes (PID Table)

| PID | Mode | Description | How to Enter |
|-----|------|-------------|--------------|
| `05c6:f006` | **HID / Charge** | Low-power USB charging. No network. | Device off, connect USB (charging only) |
| `05c6:9024` | **RNDIS** | Normal operation. USB Ethernet gadget. IP `192.168.42.129`. Web UI accessible. | Boot normally while connected to USB |
| `05c6:9008` | **EDL** | Emergency Download mode. Qualcomm QD Loader 9008. For firmware flashing/backup. | Hardware short or `adb reboot edl` |
| `05c6:f000` | **ADB** | Android Debug Bridge active. `adb shell` works. | ADB backdoor URL |
| `18d1:d00d` | **Fastboot** | Bootloader mode. `fastboot devices` detects. | Hold button while connecting USB |

## Boot State Machine

```
                    ┌──────────────────────┐
                    │   Powered Off         │
                    │   LED: none            │
                    │   USB: none            │
                    └──────────┬────────────┘
                               │ Press power 3s
                               ▼
                    ┌──────────────────────┐
                    │   Booting             │
                    │   LED: blue blinking  │
                    │   USB: HID → RNDIS    │
                    │   Time: ~30-45s       │
                    └──────────┬────────────┘
                               │
                    ┌──────────┴──────────────┐
                    │                          │
                    ▼                          ▼
        ┌──────────────────────┐   ┌──────────────────────┐
        │   Normal Operation   │   │   Fastboot Mode       │
        │   LED: G+B+P solid   │   │   LED: varies         │
        │   USB: RNDIS         │   │   USB: 18d1:d00d      │
        │   Web UI: ✅         │   │   fastboot devices    │
        │   ADB: ❌ (default)  │   │   ⬇️  oem reboot-edl  │
        └──────────┬────────────┘   └──────────┬───────────┘
                   │                            │
                   ▼                            ▼
        ┌──────────────────────┐   ┌──────────────────────┐
        │   ADB Enabled        │   │   EDL Mode            │
        │   USB: 05c6:f000     │   │   USB: 05c6:9008      │
        │   adb shell ✅       │   │   edl r/w/flash       │
        │   → adb reboot edl   │   │   No OS, no LEDs      │
        └──────────────────────┘   └──────────────────────┘
```

## How to Enter Each Mode

### Normal (RNDIS) Mode
```bash
1. Plug device into USB
2. Wait 5 seconds (device enumerates as HID)
3. Press power button briefly
4. Wait 30-45 seconds for boot
5. Device appears as 05c6:9024
6. Access web UI at http://192.168.42.129
```

### Fastboot Mode
```bash
1. Hold power button while connecting USB
2. OR: adb reboot bootloader (if ADB is active)
3. Device shows as 18d1:d00d
4. Check: fastboot devices
```

### EDL Mode (Hardware)
```bash
1. Power off device (hold button 10s)
2. Disconnect USB
3. Short D+ and GND on USB connector
   ┌─────────────────────────────┐
   │  USB-A Male Connector       │
   │  ┌───┐                      │
   │  │ 4 │  VCC                 │
   │  │ 3 │  D-                  │
   │  │ 2 │  D+  ←── short ──┐  │
   │  │ 1 │  GND ←───────────┘  │
   │  └───┘                      │
   └─────────────────────────────┘
4. Connect USB while holding short
5. Release after ~2 seconds
6. Check: lsusb → 05c6:9008
7. Use: edl rf backup.bin
```

### ADB Mode (if backdoor URL is present)
```bash
# Access from web UI:
curl http://192.168.100.1/usbdebug.html
# OR (firmware dependent):
curl http://192.168.42.129/usbdebug.html
```

## Power Button Actions

| Action | Duration | Result |
|--------|----------|--------|
| Power on | Press 3s | Boot device (if off) |
| Force off | Hold 10s | Hard shutdown |
| WiFi toggle | Quick press | Toggle WiFi (when on) |

> Note: Button behavior varies by firmware version.

## Post-Custom-OS Modes (after lk1st/lk2nd)

| Mode | Bootloader | How to Enter |
|------|-----------|--------------|
| Fastboot | lk1st/lk2nd | Insert USB while holding button |
| EDL | lk1st/lk2nd | Fastboot → `fastboot oem reboot-edl` |
| Normal | lk1st/lk2nd | Power on normally |
| UART | Any | Solder 1.8V UART pads |
