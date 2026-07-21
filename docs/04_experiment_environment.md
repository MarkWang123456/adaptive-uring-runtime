### Platform & System Environment

Platform: Raspberry Pi 4 Model B Rev 1.5
Architecture: ARM64 / Cortex-A72 / 4 cores
OS: Debian GNU/Linux 13.5
Kernel: 6.18.34+rpt-rpi-v8
fio: 3.39
liburing: 2.9
Compiler: GCC 14.2.0
Python: 3.13.5

### Storage & I/O Setup

OS device: native microSD, /dev/mmcblk0p2
Experiment device: Crucial P310 500 GB
- Model number: CT500P310SSD8
- Firmware: VACR001
- NVMe version: 2.0
- Capacity: 500,107,862,016 bytes
- Formatted LBA size: 512 bytes
- SMART health: PASSED
- Media/data integrity errors: 0
- Error log entries: 0
- SMART temperature at snapshot: 35°C

USB bridge: CyberSLIM M2-DC
- Bridge vendor: JMicron
- USB VID:PID: 152d:0586
- USB device revision: 1.01
- Exact bridge controller: unconfirmed
- Bridge firmware: not independently confirmed
- Driver: uas

Transport: USB 3.0, UASP, 5000M
Filesystem: ext4
Mount point: /mnt/nvme
Mount options: defaults,noatime,nofail
I/O scheduler: mq-deadline
CPU governor at environment snapshot: ondemand
Frequency range: 600 MHz–1800 MHz

### Thermal, Power & Network

Cooling: passive heatsinks, no fan
Case: open-top plastic base
Ambient temperature: approximately 28°C
Power: Baseus GAN07-140W, C1 port, 5 V / 3 A capability
Network: Wi-Fi and SSH retained
System target: multi-user.target