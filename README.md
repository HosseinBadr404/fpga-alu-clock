# FPGA ALU and Clock System

> **Course:** Digital Logic (مدار منطقی)

A modular Verilog design that combines a parameterized arithmetic logic unit, a clock subsystem, seven-segment display logic, and an integrated top-level module.

## Modules

- `ALU.v` — arithmetic, comparison, bitwise, and shift operations with status flags
- `Clock.v` — clock/timekeeping logic
- `Display.v` — seven-segment display driver
- `System_Top.v` — complete system integration
- `tb_*.v` — focused ALU, clock, and system testbenches

## Simulate

With Icarus Verilog installed:

```bash
iverilog -g2012 -o alu_tb ALU.v tb_ALU.v
vvp alu_tb

iverilog -g2012 -o clock_tb Clock.v tb_Clock.v
vvp clock_tb
```

## Background

This academic project emphasizes modular RTL, parameterization, explicit status signaling, and testbench-driven verification. It was created collaboratively by Hossein Badr and Hossein Tabasi Afkham.
