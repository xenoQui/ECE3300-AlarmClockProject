# ECE 3300 - FPGA Alarm Clock Implemented using Verilog

## Software & Hardware Details
Software Version: [Xilinx Vivado ML Edition - 2023.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-1.html)

Hardware: [Nexys A7-100T](https://www.xilinx.com/products/boards-and-kits/1-6olhwl.html)

## Repo Information

This repo is broken into 3 parts:
1. AlarmClock (Final/Combined)
2. Alarm (Sound)
3. Clock (Standalone)

Within each folder, the code is uploaded as v1, v2, v3... for each major change. This allows us to keep track of changes and differentiate working code with broken code.

## Uploading Code

From the Vivado project folder, upload the content within the sources folder.

The sources folder is `{ProjectName}.srcs`.

While in the **_.srcs_** folder, upload:
- constrs_#
- sim_#
- sources_#

## Changelog

- ### [AlarmClock](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock) (Combined)

  _Note: alarm_clock.v is top file v2.4_

  - [v2.4](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.4)
    - Add PWM RGB LED
    - Updated clock.v
      - clock_clk_cond has additional en == 0 condition
      - Added alarm_clk_cond for alarm load ucb
    - Added a condition to reset all clock counters when it is above 23:59
      - Occurs when clock_load is low
  
  _Note: alarmclock.v is top file v2.0 to v2.3_
  
  - [v2.3](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.3)
    - Add VGA
    - Using Final_Project_Constraints.xdc
  - [v2.2](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.2)
    - Fixed v2.1 bug
    - Updated so that all counters/load is capped at the MAX value
    - Increased alarm length to 5 mins
    - Added clock_tb.v and the respective waveform
    - Updated clock.v with a section dedicated for testbench/simulation
      - comment and uncomment sections before running simulation
    - Update clock.v - Delete alarm_load as a reset condition for minute counter
  - [v2.1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.1)
    - Changed nearly all input and output names to reduce the amount of words/letters
    - Add LEDs
      - switch to enable or disable input LEDs
      - clock en, alarm en, load for both alarm and clock, rst, minute rst
      - 4 LEDs for load number
      - 4 LEDs to show which up counter is being loaded
    - Now when alarm load is high, only the alarm portion is changed; If clock load is high, only the clock can be changed.
    - Updated [min.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/AlarmClock/v2.1/sources_1/new/min.v) to be 59, to more accurately represent 1 minute
    - Added simulation for minute [min_tb.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.1/sim_1/new)
    - ⚠️ ISSUE: Clock does not reset back to 00:00 when past 23:59
      - Currently keeps 23:00, when past 23:59
  - [v2.0](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v2.0)
    - Add alarm load functionality within clock
    - Create sound function and is played whenever the clock & alarm matches
  - [v1.1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v1.1) (**_LEDs not tested_**)
    - This is uploaded as a reference 
  - [v1.0](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/AlarmClock/v1)
    - Updated the [constraints file](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/AlarmClock/v1/constrs_1/new/Nexys-A7-100T-Master.xdc) to work with the new top file
    - Added a reset switch for the minute counter
    - clk_load is instantiated in top
    - 7 segment display code is instantiated in top
    - [clock.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/AlarmClock/v1/sources_1/new/clock.v) is instantiated within top
    - [ucb.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/AlarmClock/v1/sources_1/new/ucb.v) now uses a conditional statement instead of an always block
    - Fixed v3 Issues:
      1. For all up counters, whenever clock_load is high it uses the 100 MHz clock; else uses the minute clock
      2. The reset logic is now within an always block for every minute

- ### [Alarm](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Alarm)

  - [v1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Alarm/v1)
    - Add sound and its player

- ### [Clock](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock) (Standalone)

  _Note: clock.v is top file_
  
  - [v3](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v3) (**Imported to AlarmClock v1.0**)
    - Updated MIN_0 counter timing to be 60 secs
    - Edited [min.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/Clock/v3/sources_1/new/min.v) so that every 60 secs the counter will increment
    - Added `or posedge ucb_rst` to [ucb.v](https://github.com/Synergy5761/ECE3300-AlarmClockProject/blob/main/Clock/v3/sources_1/new/ucb.v) as a condition for the always block
      - Allows the clock to be reset at any time
    - ⚠️ Issues:
      1. Load is unable to change MIN_0 due to the minute clock
      2. When loading values into the clock, if it is 23:59 the clock automatically resets
  - [v2.1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v2.1)
    - Working 24 hour clock 00:00 -> 23:59
    - Added hour: 00 -> 23
    - Decreased clk time for load
    - Timing for MIN_0 counter is 1 Hz (increments every 1 sec)
  - [v2.0](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v2.0)
    - Rewritten code based off v1
    - Has a working minute counter 00 -> 59
    - Load also works; however, when changing to another digit the previous load value gets carried over
  - [v1](https://github.com/Synergy5761/ECE3300-AlarmClockProject/tree/main/Clock/v1) (**_DOES NOT WORK_**)
    - Initial code written for a 24 hour clock (00:00 -> 23:59)

