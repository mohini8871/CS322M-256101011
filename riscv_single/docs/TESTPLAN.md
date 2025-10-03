# Test Plan for RVX10 Single-Cycle CPU

This document describes the testing strategy to validate the RV32I + RVX10 implementation.

---

## Objectives
- Verify correctness of base RV32I instructions (ADD, SUB, AND, OR, SLT, LW, SW, BEQ, JAL).
- Verify correctness of 10 new RVX10 custom instructions (ANDN, ORN, XNOR, MIN, MAX, MINU, MAXU, ROL, ROR, ABS).
- Ensure no regressions in control flow, memory access, and branch/jump instructions.

---

## Test Infrastructure
- **Simulation tool:** Icarus Verilog (iverilog + vvp).  
- **Waveform viewer:** GTKWave with VCD dumps enabled.  
- **Memory initialization:** `$readmemh` loads `.hex` program files into instruction memory.  
- **Pass/Fail check:** Testbench prints `"Simulation succeeded"` when memory[100] = 25, else `"Simulation failed"`.

---

## Test Cases

### 1. Base ISA Regression
- **Input program:** `riscvtest.txt`
- **Expected behavior:**
  - Executes add/sub/and/or/xor/slti etc.
  - Writes final result 25 to memory address 100.
  - Testbench prints `"Simulation succeeded"`.

### 2. RVX10 Functional Tests
- **Input program:** `rvx10.hex`
- **Covers:**  
  - **Bitwise ops:** ANDN, ORN, XNOR  
  - **Compare ops:** MIN, MAX, MINU, MAXU  
  - **Rotate ops:** ROL, ROR  
  - **Unary op:** ABS  
- **Expected behavior:**  
  - For each instruction, manually verified result matches ALU spec.  
  - Key outputs monitored via `WriteData`, `DataAdr` in waveform.  
  - Example: ROL by 1 of `0x80000000` produces `0x00000001`.  

### 3. Edge Cases
- **ROL/ROR**: test with `shamt=0` (output must equal input).  
- **ABS**: test with negative and zero values.  
- **MIN/MAX**: test equal inputs (result must equal rs1/rs2).  
- **Signed vs Unsigned**: verify MIN vs MINU on same inputs.  

---

## Verification Metrics
- **Waveform inspection** for correctness of ALUControl codes (5-bit) and results.  
- **Final memory content** checked against golden expected value.  
- **No warnings** from `$readmemh` once memory indexing corrected.  

---

## Status
- Base tests (`riscvtest.txt`) passed → ✅  
- Extended tests (`rvx10.hex`) executed successfully with `"Simulation succeeded"` → ✅  
- Next step: run waveform inspection for all custom instructions → In progress.  
