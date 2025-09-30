# RVX10 - 10 New Single-Cycle instruction to the RV32I core
### pipeline
## Goal 
extend single-cycle RV32I core with 10 new instruction - RVX10
use the reserved CUSTOM -0 opcode (0x0B)
    - single cycle
    - use existing datapath elements (adder, shifter, etc.)
    - no new CSRs, write results back only to register file
### success 
    final testbench - 25 store at memory 100
## 📂 Project Structure
riscv_single/
│
├── src/
│ └── riscv_single.sv # modified single-cycle core (ALU + decode)
│
├── docs/
│ ├── ENCODINGS.md # binary + hex encodings of RVX10 ops
│ ├── TESTPLAN.md # test strategy & expected outputs
│
├── tests/
│ ├── rvx10.S # assembly test program
│ └── rvx10.hex # compiled memory image for simulation
│
└── README.md # build & run instructions

## modify RTL (risvsingle.sv)

## ⚙️ Build & Simulation Instructions

### 1. Assemble the Test Program
```bash
riscv64-unknown-elf-as -march=rv32i -o rvx10.o tests/rvx10.S
riscv64-unknown-elf-objcopy -O verilog rvx10.o tests/rvx10.hex
```
### 2. Run Simulation
using Icarus verilog

```bash
iverilog -g2012 -o simv src/riscv_single.sv tb/tb_riscv_single.sv
vvp simv
```

