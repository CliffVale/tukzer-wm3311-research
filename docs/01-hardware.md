# Hardware Specifications

## Device Identification

**Tukzer WM3311** (also sold as "Turbo U2", model TZ-WD-02) is a white-label rebrand of the **UZ801 v3.x** 4G LTE dongle. The board inside is marked `FY_UZ801_V2.1`, `V3.0`, or `V3.2`. All UZ801 hacking resources apply directly.

| Branding | Model | Board Marking |
|----------|-------|---------------|
| Tukzer | WM3311 (TZ-WD-02) | FY_UZ801_V2.1 |
| Generic | UZ801 v3.0 / v3.2 | FY_UZ801_V2.1 / V3.0 / V3.2 |
| Generic | UF896 | THWC_UF896 |
| Generic | UFI001B/C, UFI003 | Various |

### Our Device
- **SN:** 10210203393
- **IMEI:** 866755026828238
- **Build fingerprint:** `True/HL6180W/HL6180W:4.4.4/KTU84P/eng.lbcsu.20210907:eng/release-keys`
- **ODM:** CHUANGJING (Shenzhen) — model SP971_HW_V2
- **Build date:** September 7, 2021

## System-on-Chip: Qualcomm MSM8916

The heart of the dongle is the Qualcomm Snapdragon 410 (MSM8916), a 64-bit ARM Cortex-A53 quad-core SoC designed for entry-level smartphones.

| Component | Specification |
|-----------|---------------|
| **CPU** | 4× ARM Cortex-A53 @ 1.0-1.2 GHz (stock: only 2 cores enabled) |
| **GPU** | Qualcomm Adreno 306 |
| **DSP** | Hexagon QDSP6 |
| **Video** | 1080p30 encode/decode |
| **RAM** | 512MB LPDDR2/LPDDR3 (~397MB usable, ~80MB reserved for modem DSP) |
| **eMMC** | 2GB (3,817,472 blocks × 512 bytes = ~1.82 GiB) |
| **Modem** | Qualcomm MDM9x07 (integrated via PCIe/SDIO) |
| **USB** | USB 2.0 High Speed with OTG |
| **Process** | 28nm LP |

## Memory Map

### RAM Usage

From live device:
```
MemTotal:         397824 kB  (~388 MB usable)
SwapTotal:        196604 kB  (~192 MB zram swap)
```

The modem DSP reserves ~80MB for its own operation.

### Partition Table (GPT)

From live `/proc/partitions`:

| Partition | Start Block | Size (blocks) | Size (human) | Contents |
|-----------|-------------|---------------|--------------|----------|
| mmcblk0p1 | 1 | 65536 | 32 MB | boot |
| mmcblk0p2 | 65537 | 512 | 256 KB | sbl1 |
| mmcblk0p3 | 66049 | 512 | 256 KB | sbl1bak |
| mmcblk0p4 | 66561 | 1024 | 512 KB | rpm |
| mmcblk0p5 | 67585 | 1024 | 512 KB | rpmbak |
| mmcblk0p6 | 68609 | 512 | 256 KB | tz |
| mmcblk0p7 | 69121 | 512 | 256 KB | tzbak |
| mmcblk0p8 | 69633 | 512 | 256 KB | hyp |
| mmcblk0p9 | 70145 | 512 | 256 KB | hypbak |
| mmcblk0p10 | 70657 | 512 | 256 KB | DDR |
| mmcblk0p11 | 71169 | 512 | 256 KB | sec |
| mmcblk0p12 | 71681 | 1024 | 512 KB | aboot |
| mmcblk0p13 | 72705 | 1536 | 768 KB | abootbak |
| mmcblk0p14 | 74241 | 1536 | 768 KB | fsg |
| mmcblk0p15 | 75777 | 1024 | 512 KB | fsc |
| mmcblk0p16 | 76801 | 1 | 512 B | ssd |
| mmcblk0p17 | 76802 | 8 | 4 KB | misc |
| mmcblk0p18 | 76810 | 10240 | 5 MB | modem |
| mmcblk0p19 | 87050 | 32 | 16 KB | pad |
| mmcblk0p20 | 87082 | 1536 | 768 KB | modemst1 |
| mmcblk0p21 | 88618 | 16 | 8 KB | splash |
| mmcblk0p22 | 88634 | 16384 | 8 MB | persist |
| mmcblk0p23 | 105018 | 819200 | 400 MB | system |
| mmcblk0p24 | 924218 | 32768 | 16 MB | recovery |
| mmcblk0p25 | 956986 | 131072 | 64 MB | cache |
| mmcblk0p26 | 1088058 | 16384 | 8 MB | (unknown) |
| mmcblk0p27 | 1104442 | 2603455 | 1.27 GB | userdata |

**Total:** 3,817,472 blocks ≈ 1.82 GiB (advertised as 2GB eMMC)

## LTE Bands

| Band Type | Band | Frequency |
|-----------|------|-----------|
| UTRAN | 1 | 2100 MHz |
| UTRAN | 8 | 900 MHz |
| EUTRAN | 1 | 2100 MHz |
| EUTRAN | 3 | 1800 MHz |
| EUTRAN | 5 | 850 MHz |
| EUTRAN | 7 | 2600 MHz |
| EUTRAN | 8 | 900 MHz |
| EUTRAN | 20 | 800 MHz |
| EUTRAN | 38 | 2600 MHz TDD |
| EUTRAN | 40 | 2300 MHz TDD |
| EUTRAN | 41 | 2500 MHz TDD |

## Physical Specifications

- **Dimensions:** 9.9 × 6.1 × 1 cm
- **Weight:** ~120g
- **Battery:** 2100mAh Li-Po (6hr continuous / 3 day standby)
- **USB:** Micro USB 2.0 (peripheral + OTG host via dock)
- **Buttons:** 1× power/multi-function
- **LEDs:** 3 — Battery (green), WiFi (blue), Network (purple/red)
- **Antenna:** Built-in PCB antenna (U.FL connector on board for external)

## Board Pinouts

### UART (for serial console)
- **Voltage: 1.8V** — do NOT use 3.3V or 5V serial adapters without level shifting
- **Baud:** 115200 8N1
- **Pads:** Located near the edge of the board (refer to pmOS wiki for exact locations)

### EDL Test Points
Two methods to enter EDL:
1. **USB pin short:** Short D+ and GND on the USB connector while inserting
2. **PCB pads:** Two exposed pads near the SoC (bridge with tweezers)

### External Antenna
U.FL connector on PCB for external LTE antenna (main + diversity).
