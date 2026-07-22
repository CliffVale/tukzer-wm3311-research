#!/bin/bash
# Tukzer WM3311 / UZ801 — Device Probe Script
# Checks current device state and reports everything
# Usage: ./probe-device.sh [DEVICE_IP]

DEVICE_IP="${1:-192.168.42.129}"
AUTH="--digest -u admin:admin"
BASE="http://${DEVICE_IP}"

echo "=== Tukzer WM3311 Device Probe ==="
echo "Target: ${DEVICE_IP}"
echo ""

echo "--- 1. USB Mode ---"
lsusb | grep -E '05c6|18d1' || echo "Device not detected via USB"

echo ""
echo "--- 2. Network ---"
ip route | grep "${DEVICE_IP}" || echo "No route to device"

echo ""
echo "--- 3. Web UI ---"
curl -s $AUTH -o /dev/null -w "%{http_code}" "${BASE}/" && echo " OK" || echo " FAIL"

echo ""
echo "--- 4. SL4A API ---"
curl -s $AUTH -X POST -H "Content-Type: application/json" \
  -d '{"id":0,"method":"getDeviceState","params":[]}' \
  "${BASE}/sl4a" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "SL4A error"

echo ""
echo "--- 5. Partition Table ---"
curl -s $AUTH "${BASE}/files/proc/partitions" 2>/dev/null

echo ""
echo "--- 6. Build Info ---"
curl -s $AUTH "${BASE}/files/system/build.prop" 2>/dev/null | grep -E 'ro.build|ro.product|ro.secure' | head -10

echo ""
echo "--- 7. USB Gadget Mode ---"
echo -n "Functions: "
curl -s $AUTH "${BASE}/files/sys/class/android_usb/android0/functions" 2>/dev/null
echo ""
echo -n "PID: "
curl -s $AUTH "${BASE}/files/sys/class/android_usb/android0/idProduct" 2>/dev/null
echo ""

echo ""
echo "--- 8. Battery ---"
curl -s $AUTH -X POST -H "Content-Type: application/json" \
  -d '{"id":0,"method":"getBatteryLevel","params":[]}' \
  "${BASE}/sl4a" 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(str(d.get('result','?'))+'%')" 2>/dev/null
