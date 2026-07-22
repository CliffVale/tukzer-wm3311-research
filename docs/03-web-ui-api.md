# Web UI & API

The stock firmware runs **Webkey for Android** — a third-party remote control app — as the primary web interface, powered by the **Mongoose** embedded HTTP server. It also exposes SL4A (Scripting Layer for Android) for backend communication.

## Access

| Interface | IP | Port | Auth |
|-----------|-----|------|------|
| RNDIS USB | `http://192.168.42.129` | 80 | Digest (`admin`/`admin`) |
| WiFi AP | `http://192.168.43.1` | 80 | Digest (`admin`/`admin`) |

## Key Discovery: Full Filesystem Access

**The `/files/` endpoint exposes the ENTIRE Android root filesystem**, including raw block devices:

```
http://192.168.42.129/files/
├── proc/
│   ├── partitions       ← Partition table ← **THIS IS KEY**
│   ├── cpuinfo
│   ├── meminfo
│   └── ...
├── dev/
│   ├── block/
│   │   ├── mmcblk0      ← Raw eMMC (full firmware)
│   │   └── bootdevice/by-name/
│   │       ├── aboot    ← Bootloader
│   │       ├── boot     ← Boot image
│   │       ├── system   ← System partition
│   │       ├── modem    ← Modem firmware
│   │       └── ...      ← All 27 partitions
├── system/
│   ├── build.prop       ← Build properties
│   ├── priv-app/        ← System apps (MifiService.apk)
│   └── ...
├── data/                ← User data
├── sdcard/              ← SD card
└── ...
```

**This means:** full firmware backup with nothing but `curl`.

## Web Interface Pages

| Path | Description |
|------|-------------|
| `/` | Main login page (Digest auth) |
| `/phone.html` | Device info, battery, signal |
| `/config` | Admin config, user management, permissions, logs |
| `/terminal.html` | ShellInABox web terminal (iframe → `/terminal2.html`) |
| `/files/` | Full filesystem browser |
| `/system.html` | Webkey control panel |
| `/screenshot.jpg` | Live screen capture |
| `/sms.html` | SMS management |
| `/gps.html` | GPS/location |
| `/calls.html` | Call log |
| `/net.html` | Network stats |
| `/export.html` | Data export |
| `/sdcard.html` | SD card access |
| `/help.html` | Help page |

## SL4A JSON-RPC API

The web UI communicates with the Android system via SL4A at `/sl4a`:

### Request Format
```json
POST /sl4a
{"id": 0, "method": "METHOD_NAME", "params": []}
```

### Discovered Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `getDeviceState` | Full device state object | Battery, SIM, signal, network, data |
| `getSL4Aflag` | `"ready"` | Check if SL4A is alive |
| `getMCCMNC` | `""` (string) | Mobile Country Code / Network Code |
| `getBatteryLevel` | `"100"` | Battery percentage |
| `getNetworkType` | `"unknown"` | Network type string |
| `getClipboard` | null (error) | Clipboard content (requires Looper) |
| `externalStorageMounted` | boolean | SD card status |
| `clearStatistics` | null | Clear data usage stats |

### Slower / Batched Endpoints

| Endpoint | Purpose |
|----------|---------|
| `/sl4a` | Single SL4A request |
| `/sl4as` | Batched SL4A requests (returns array) |
| `/sl4ascached` | Cached batched SL4A requests |

### Example: Get Full Device State
```bash
curl -s --digest -u admin:admin \
  -X POST -H "Content-Type: application/json" \
  -d '{"id":0,"method":"getDeviceState","params":[]}' \
  http://192.168.42.129/sl4a
```

Response:
```json
{
  "error": null,
  "id": 0,
  "result": {
    "BatteryLevel": "100",
    "BatteryStatus": "Full",
    "ClientsNumber": "0",
    "DataConnectivity": "UNKNOWN",
    "EthernetConnectivityAvailable": false,
    "LAN_enable": true,
    "LAN_insert": false,
    "MobileTotalBytes": "0.0 Bytes",
    "NetworkOperatorName": "",
    "NetworkType": "unknown",
    "Signal": 0,
    "SimState": 1,
    "UnreadSmsCount": 0
  }
}
```

### SL4A Batched Example
```bash
curl -s --digest -u admin:admin \
  -X POST -H "Content-Type: application/json" \
  -d '[{"id":1,"method":"getDeviceState","params":[]},{"id":2,"method":"getBatteryLevel","params":[]}]' \
  http://192.168.42.129/sl4as
```

## Admin Config Page

Accessible at `/config` (authenticated):

- **Change password**
- **Create/remove users**
- **Permissions system** — Screenshot, Location, Chat, Read files, SMS, etc.
- **Activity log** — Shows all recent activity including SL4A calls

### Permission Levels
- **ALL** — Full access including key injection, touch events, command execution, terminal
- **Screenshot** — View device screen
- **Location** — GPS and network location
- **Chat** — Read/write messages
- **Files** — Read all files (includes passwords!)
- **Sdcard** — Read/write SD card

## Logs (from /config)

```
[25/03/2023 19:35] service's started try!!!
[25/03/2023 19:35] service's started
mongoose cry: test2 Error 404: Not Found
[25/03/2023 19:37] admin: sl4a
```

The web server (Mongoose) logs all activity including 404 errors.

## USB Gadget State

Current configuration via `/files/sys/class/android_usb/android0/`:

| File | Value |
|------|-------|
| `functions` | `rndis` |
| `enable` | `1` |
| `idVendor` | `05c6` |
| `idProduct` | `9024` |
| `iManufacturer` | `Qualcomm` |
| `iProduct` | `Android` |
| `iSerial` | `123456789123` |

The USB gadget is set to **RNDIS only** (no ADB). Available functions include `f_adb`, `f_mtp`, `f_serial`, `f_mass_storage`, etc.
