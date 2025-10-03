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
```
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
```
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
```

To add 10 new ops:

Introduce a new opcode: CUSTOM-0 = 0x0B (0001011b) from the assignment brief. 

CS322M_Assignment_single-1

Expand ALUControl from 3 bits to 5 bits so we have space for the new operations.

Teach maindec to mark CUSTOM-0 as ALU operation (no memory/branch/jump).

Teach aludec how to decode CUSTOM-0 via (funct7,funct3) to the 10 new 5-bit ALU codes.

Implement the 10 ops inside alu (ANDN/ORN/XNOR/MIN/MAX/MINU/MAXU/ROL/ROR/ABS) with the 
correct semantics (rotate by 0 = passthrough; ABS uses two’s complement wrap).
```
