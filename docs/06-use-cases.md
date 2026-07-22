# Use Cases

The Tukzer WM3311 / UZ801 is a tiny Linux computer with built-in 4G LTE, WiFi, USB, and a battery — here's what you can build with it.

## Network & Routing

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 1 | **OpenWrt Router** | OpenWrt | Full LuCI, firewall, QoS, VLAN |
| 2 | **4G LTE Failover** | OpenWrt | Auto-failover when primary ISP down |
| 3 | **Tailscale Exit Node** | OpenWrt/Alpine | Route traffic through 4G remotely |
| 4 | **WireGuard VPN** | Any | Server or client, encrypted tunnel |
| 5 | **Travel Router** | OpenWrt | Hotel WiFi → secure private network |
| 6 | **WiFi Repeater** | OpenWrt | Extend existing WiFi coverage |

## DNS & Ad-Blocking

| # | Use Case | OS | RAM |
|---|----------|----|-----|
| 7 | **Pi-hole** | Debian/Alpine | ~50MB |
| 8 | **AdGuard Home** | Debian/Alpine | ~80-150MB |
| 9 | **DNS-over-HTTPS/TLS** | Debian/Alpine | ~20MB |
| 10 | **Unbound Recursive DNS** | Debian/Alpine | ~30MB |

## Security & Pentesting

| # | Use Case | OS | Description |
|---|----------|----|-------------|
| 11 | **P4wnP1-LTE** | Debian | USB attack platform (BadUSB + LTE C2) |
| 12 | **Rayhunter** | Debian | IMSI catcher detector (EFF) |
| 13 | **Network Sniffer** | Debian | MITM with Bettercap/tcpdump |
| 14 | **Remote Pentest Box** | Debian | 4G-accessible attack platform |
| 15 | **HID Rubber Ducky** | Debian/USB Gadget | Keystroke injection over USB |
| 16 | **WiFi Security Testing** | Debian | aircrack-ng, airgeddon |

## Monitoring & Dashboards

| # | Use Case | OS | RAM |
|---|----------|----|-----|
| 17 | **Uptime Kuma** | Alpine/Debian | ~100-150MB |
| 18 | **Homer Dashboard** | Alpine | ~10MB (static) |
| 19 | **Prometheus Node Exporter** | Any | ~20MB |
| 20 | **Zabbix Agent** | Any | ~30MB |
| 21 | **Netdata** | Debian/Alpine | ~50-100MB |

## Messaging & Communication

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 22 | **Telegram Bot** | Debian/Alpine | Python, ~40-80MB RAM |
| 23 | **SMS Gateway** | Any | Send/receive SMS via web API |
| 24 | **Email Relay** | Debian | Postfix for outbound email |
| 25 | **Matrix/Synapse** | Debian | Very constrained on 512MB RAM |

## File Sharing & Storage

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 26 | **Samba File Server** | Debian/Alpine | USB storage share |
| 27 | **USB Mass Storage Gadget** | Any | Act as USB flash drive |
| 28 | **Cloud Sync Gateway** | Debian | USB storage → cloud |
| 29 | **Simple NAS** | Debian | Lightweight file server |

## IoT & Home Automation

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 30 | **Home Assistant** | Debian | Under 512MB — lightweight config |
| 31 | **MQTT Broker (Mosquitto)** | Any | ~10MB RAM |
| 32 | **OctoPrint** | Alpine | 3D printer via USB OTG host |
| 33 | **Sensor Gateway** | Debian | BLE/Zigbee via USB dongle |

## Drone & GPS

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 34 | **Drone Companion** | Debian/Alpine | MavLink forwarding, onboard logic |
| 35 | **GPS Receiver** | Any | mmcli --location-enable-gps-nmea |
| 36 | **AGPS Server** | Any | Faster GPS fixes |

## Remote Access

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 37 | **Tor Hidden Service** | Any | Anonymous remote SSH |
| 38 | **Reverse SSH Tunnel** | Any | Access behind NAT/CGNAT |
| 39 | **Cloudflare Tunnel** | Debian/Alpine | Expose services without public IP |
| 40 | **Ngrok/Frp** | Any | Tunnel to internet |

## Infrastructure

| # | Use Case | OS | Notes |
|---|----------|----|-------|
| 41 | **Zoraxy Reverse Proxy** | Alpine | HTTPS termination + web dashboard |
| 42 | **NTP Server (Chrony)** | Any | Time sync for offline networks |
| 43 | **DHCP Server (dnsmasq)** | Any | Local network DHCP |
| 44 | **Load Balancer (HAProxy)** | Debian | Traffic distribution |
