# ECE 3300 - Alarm Clock Final Project

## Software & Hardware Details
Software Version: [Xilinx Vivado ML Edition - 2023.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-1.html)

Hardware: [Nexys A7-100T](https://www.xilinx.com/products/boards-and-kits/1-6olhwl.html)

## Repo Information

This repo is broken into 3 parts:
- Alarm (Standalone)
- Clock (Standalone)
- AlarmClock (Combined)

Within each folder, the code is uploaded as v1, v2, v3... for each major change. This allows us to keep track of changes and differentiate working code with broken code.

## Uploading Code

From the Vivado project folder, upload the content within the sources folder.

The sources folder is `{ProjectName}.srcs`.

While in the **_.srcs_** folder, upload:
- constrs_#
- sim_#
- sources_#

## Changelog

### [Alarm](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Alarm) (Standalone)
- [v1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Alarm/v1)
  - WIP

### [Clock](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock) (Standalone)

- [v2.1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v2.1)
  - Working 24 hour clock 00:00 -> 23:59
  - Added hour: 00 -> 23
  - Decreased clk time for load
  - Timing for MIN_0 counter is 1 Hz (increments every 1 sec)
- [v2.0](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v2.0)
  - Rewritten code based off v1
  - Has a working minute counter 00 -> 59
  - Load also works; however, when changing to another digit the previous load value gets carried over.
- [v1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v1) (**_DOES NOT WORK_**)
  - Initial code written for a 24 hour clock (00:00 -> 23:59)

### Alarm Clock (Combined)
- v1
  - WIP
