#!/bin/bash
# Tukzer WM3311 / UZ801 Firmware Backup via Web Filesystem
# Reads each partition from the device through the web UI
# Usage: ./backup-firmware.sh [DEVICE_IP]

DEVICE_IP="${1:-192.168.42.129}"
AUTH="--digest -u admin:admin"
OUTDIR="$(dirname "$0")/../firmware/stock-backup-$(date +%Y%m%d)"
mkdir -p "$OUTDIR"
BASE_URL="http://${DEVICE_IP}/files/dev/block"

echo "=== Tukzer WM3311 Firmware Backup ==="
echo "Device: $DEVICE_IP"
echo "Output: $OUTDIR"
echo ""

echo "=== Phase 1: Small Partitions (critical) ==="
for name in sbl1 aboot rpm tz hyp fsc fsg modemst1 modemst2 sec misc DDR splash ssd pad; do
  echo -n "  $name → "
  curl -s $AUTH -o "${OUTDIR}/${name}.bin" \
    "${BASE_URL}/bootdevice/by-name/${name}"
  if [ -f "${OUTDIR}/${name}.bin" ]; then
    SIZE=$(stat -c%s "${OUTDIR}/${name}.bin" 2>/dev/null)
    echo "${SIZE} bytes saved"
  else
    echo "FAILED"
  fi
done

echo ""
echo "=== Phase 2: Modem firmware (critical for IMEI) ==="
for name in modem; do
  echo -n "  $name → "
  curl -s $AUTH -o "${OUTDIR}/${name}.bin" \
    "${BASE_URL}/bootdevice/by-name/${name}"
  SIZE=$(stat -c%s "${OUTDIR}/${name}.bin" 2>/dev/null)
  echo "${SIZE} bytes saved"
done

echo ""
echo "=== Phase 3: Boot partitions ==="
for name in boot recovery persist; do
  echo -n "  $name → "
  curl -s $AUTH -o "${OUTDIR}/${name}.bin" \
    "${BASE_URL}/bootdevice/by-name/${name}"
  SIZE=$(stat -c%s "${OUTDIR}/${name}.bin" 2>/dev/null)
  echo "${SIZE} bytes saved"
done

echo ""
echo "=== Phase 4: System partition (400MB - may take a while) ==="
echo -n "  system → "
curl -s $AUTH -o "${OUTDIR}/system.bin" \
  "${BASE_URL}/bootdevice/by-name/system"
SIZE=$(stat -c%s "${OUTDIR}/system.bin" 2>/dev/null)
echo "${SIZE} bytes"

echo ""
echo "=== Phase 5: Verification ==="
echo "=== File sizes ==="
ls -lh "${OUTDIR}/"*.bin 2>/dev/null | sort -k5 -h

echo ""
echo "=== MD5 checksums ==="
for f in "${OUTDIR}/"*.bin; do
  md5sum "$f" 2>/dev/null
done > "${OUTDIR}/md5sums.txt"
echo "Checksums saved to ${OUTDIR}/md5sums.txt"

echo ""
echo "=== Backup Complete ==="
echo "Location: ${OUTDIR}"
echo "Files: $(ls -1 ${OUTDIR}/*.bin 2>/dev/null | wc -l)"
echo "Total: $(du -sh ${OUTDIR}/ 2>/dev/null | cut -f1)"

echo ""
echo "=== Verify key partitions ==="
echo -n "boot: "; xxd -l 8 "${OUTDIR}/boot.bin" | head -1
echo -n "splash: "; xxd -l 8 "${OUTDIR}/splash.bin" | head -1
echo -n "sbl1: "; xxd -l 4 "${OUTDIR}/sbl1.bin" | head -1
echo -n "modem: "; xxd -l 8 "${OUTDIR}/modem.bin" | head -1
echo -n "system: "; xxd -s 1024 -l 2 "${OUTDIR}/system.bin" | head -1
