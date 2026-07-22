# References

## GitHub Repositories

| Repository | Description |
|------------|-------------|
| [UZ801-USB_MODEM](https://github.com/iterminatorheart/UZ801-USB_MODEM) | Comprehensive UZ801 analysis, EDL guide, OpenWrt/Debian |
| [msm8916-openwrt](https://github.com/hkfuertes/msm8916-openwrt) | Modern OpenWrt (kernel 6.12+), modem+WiFi+USB gadget |
| [msm8916-alpine](https://github.com/hkfuertes/msm8916-alpine) | Alpine Linux with Docker, OctoPrint, Zoraxy profiles |
| [OpenStick](https://github.com/OpenStick/OpenStick) | Original OpenStick project (HandsomeYingyan) |
| [OpenStick-Builder](https://github.com/tomasbrincil/OpenStick-Builder) | Debian image builder with multiple board support |
| [OpenStick-Builder (fork)](https://github.com/kinsamanka/OpenStick-Builder) | OpenStick Builder fork (Debian/Alpine) |
| [uz801](https://github.com/u0d7i/uz801) | UZ801 EDL backup guide, hardware documentation |
| [UZ801-LTE-USB-MODEM](https://github.com/theXappy/UZ801-LTE-USB-MODEM) | Web UI/API research, AT commands, Wake-on-LAN |
| [lk2nd](https://github.com/msm8916-mainline/lk2nd) | Bootloader (lk1st/lk2nd) for MSM8916 devices |
| [bkerler/edl](https://github.com/bkerler/edl) | Qualcomm EDL flashing tool |
| [qhypstub](https://github.com/msm8916-mainline/qhypstub) | Qualcomm hypervisor stub for mainline |
| [sms-server](https://github.com/morgverd/sms-server) | SMS gateway for MSM8916 |
| [sms-bridge](https://github.com/guykouame/sms-bridge) | SMS bridge web interface |

## Guides & Tutorials

| Guide | Author | Description |
|-------|--------|-------------|
| [OpenStick Guide](https://wvthoog.nl/openstick/) | Wim van 't Hoog | Debian, USB gadget, Tor, pentesting |
| [Original OpenStick Guide](https://extrowerk.com/2022-07-31/OpenStick.html) | Zoltán Mizse | First English OpenStick guide |
| [P4wnP1-LTE](https://sensepost.com/blog/2023/p4wnp1-lte/) | SensePost | USB attack platform with LTE C2 |
| [pmOS UZ801 Guide](https://ryjelsum.me/homelab/uz801-v3.2-postmarketos/) | Ryjelsum | lk1st/lk2nd + pmOS flashing |
| [pmOS Wiki](https://wiki.postmarketos.org/wiki/Zhihe_series_LTE_dongles_(generic-zhihe)) | postmarketOS | Comprehensive device support |
| [pmOS Micro-Server](https://industrialmonitordirect.com/blogs/knowledgebase/repurposing-4g-lte-modems-as-postmarketos-micro-servers) | Industrial Monitor Direct | pmOS as micro-server |
| [U4GO Yocto](https://blog.iohub.dev/u4go-open-usb-4g/) | iohub | Yocto Linux for MSM8916 |
| [MSM8916 Linux Port](https://notes.stavros.io/build-notes/msm8916-lte-stick-linux-port/) | Stavros | Personal build notes |
| [Hackaday Overview](https://hackaday.com/2022/08/03/hackable-20-modem-combines-lte-and-pi-zero-w2-power/) | Hackaday | General overview |
| [Rayhunter](https://efforg.github.io/rayhunter/uz801.html) | EFF | IMSI catcher detector |
| [Web UI Modding (Part 1)](https://www.blinkenlights.ch/ccms/posts/aliexpress-lte-1/) | Blinkenlights | Web UI modification |
| [Web UI Modding (Part 2)](https://www.blinkenlights.ch/ccms/posts/aliexpress-lte-2/) | Blinkenlights | Web UI modification |
| [GPS Experiments](https://selter.co.uk/tag/msm8916/) | Selter | MSM8916 GPS |
| [OpenStick Chinese Wiki](https://www.kancloud.cn/handsomehacker/openstick/2636505) | HandsomeYingyan | Chinese wiki (translate) |

## Forums

| Forum | Language | Topic |
|-------|----------|-------|
| [OpenWrt Forum](https://forum.openwrt.org/t/uf896-qualcomm-msm8916-lte-router/131712) | English | MSM8916 OpenWrt |
| [4PDA Forum](https://4pda.to/forum/index.php?showtopic=849043) | Russian | General discussion |

## Tools

| Tool | Purpose | Install |
|------|---------|---------|
| [bkerler/edl](https://github.com/bkerler/edl) | EDL flashing/backup | `pip install edl` or clone |
| [Android SDK Platform Tools](https://developer.android.com/tools/releases/platform-tools) | ADB + fastboot | `apt install adb fastboot` |
| [QPST](https://qpsttool.com/) | Qualcomm modem firmware | Windows only |
| [QCSuper](https://github.com/P1sec/QCSuper) | 3G/4G traffic sniffing | Python |
| [apktool](https://apktool.org/) | Android APK decompiling | Java |
| [mkbootimg](https://android.googlesource.com/platform/system/tools/mkbootimg/) | Boot image builder | AOSP |

## Build Properties (from live device)

| Property | Value |
|----------|-------|
| ro.build.id | KTU84P |
| ro.build.display.id | M8916_MD.C14.APE02/BP002 |
| ro.build.version.release | 4.4.4 |
| ro.build.version.sdk | 19 |
| ro.build.date | Tue Sep 7 09:49:42 CST 2021 |
| ro.product.model | SP971_HW_V2 |
| ro.product.manufacturer | CHUANGJING |
| ro.product.board | msm8916 |
| ro.product.cpu.abi | armeabi-v7a |
| ro.secure | 0 |
| ro.debuggable | 1 |
| persist.sys.usb.config | adb |
| ro.serialno | 123456789123 |
