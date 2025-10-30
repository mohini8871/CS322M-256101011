# RVX10‑P Instruction Encoding

This document specifies the 32‑bit instruction encodings used by the **RVX10‑P** five‑stage pipelined core.  
The core implements the base **RV32I** ISA plus **10 custom ALU operations** (the “RVX10” set): `ANDN, ORN, XNOR, MIN, MAX, MINU, MAXU, ROL, ROR, ABS`.

> **Important — keep consistent with your single‑cycle assignment:**  
> The RVX10 encodings below use the **CUSTOM‑0 opcode (0b0001011)** so they do not conflict with standard RV32I encodings. If your previous (“riscv_single”) submission used different opcodes/funct fields, **update the RVX10 table in this file to match your prior encodings** so both projects assemble and run the same test programs.

---

## 1) RISC‑V Base Formats (RV32I)

All instructions are 32 bits. Bit indexing is `[31:0]` (MSB…LSB).

### R‑type (register‑register ALU)

```
31         25 24   20 19   15 14   12 11    7 6      0
+------------+-------+-------+-------+--------+--------+
|  funct7    |  rs2  |  rs1  | funct3|   rd   | opcode |
+------------+-------+-------+-------+--------+--------+
```

- `opcode=0b0110011` (standard RV32I ALU)
- Examples (RV32I): `ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND`

### I‑type (immediate ALU, loads, JALR, system)

```
31                20 19   15 14   12 11    7 6      0
+-------------------+-------+-------+--------+--------+
|       imm[11:0]   |  rs1  | funct3|   rd   | opcode |
+-------------------+-------+-------+--------+--------+
```

- ALU‑immediates: `opcode=0b0010011` (`ADDI`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI`, `SLTI`, `SLTIU`)
- Loads: `opcode=0b0000011` (`LB/LH/LW/LBU/LHU`)

### S‑type (stores)

```
31         25 24   20 19   15 14   12 11    7 6      0
+------------+-------+-------+-------+--------+--------+
| imm[11:5]  |  rs2  |  rs1  | funct3| imm[4:0]|opcode |
+------------+-------+-------+-------+--------+--------+
```

- Stores: `opcode=0b0100011` (`SB/SH/SW`)

### B‑type (branches)

```
31   30 25 24   20 19   15 14   12 11    8 7     6 6      0
+-----+-------+-------+-------+--------+--------+--------+
|imm12|imm10:5|  rs2  |  rs1  | funct3|imm4:1  |imm11|opcode|
+-----+-------+-------+-------+--------+--------+--------+
```

- Branches: `opcode=0b1100011` (`BEQ, BNE, BLT, BGE, BLTU, BGEU`)

### U‑type (LUI/AUIPC)

```
31                      12 11    7 6      0
+-------------------------+--------+--------+
|           imm[31:12]    |   rd   | opcode |
+-------------------------+--------+--------+
```

- `LUI` (`opcode=0b0110111`), `AUIPC` (`opcode=0b0010111`)

### J‑type (JAL)

```
31   30   21 20 19    12 11    7 6      0
+-----+--------+--+--------+--------+--------+
|imm20|imm10:1 |imm11|imm19:12|  rd  | opcode |
+-----+--------+--+--------+--------+--------+
```

- `JAL` (`opcode=0b1101111`), `JALR` is I‑type with `opcode=0b1100111`

---

## 2) RVX10 Custom ALU Encoding (course‑local)

- **Opcode (CUSTOM‑0)**: `opcode = 0b0001011` (0x0B)  ← reserved for user‑defined ops
- **Format**: **R‑type layout** (same field positions as standard R‑type)
- **Register rules**: `x0` is always zero; writes to `rd=0` are ignored by the core
- **ABS** is unary: encode with `rs2=0` (hardware ignores `rs2`)

> Using CUSTOM‑0 keeps the RVX10 ops orthogonal to RV32I. Toolchains may not know these mnemonics; for tests, emit raw words in `.hex` or provide a local assembler macro table.

### RVX10 R‑type layout under CUSTOM‑0

```
31         25 24   20 19   15 14   12 11    7 6      0
+------------+-------+-------+-------+--------+--------+
|  funct7    |  rs2  |  rs1  | funct3|   rd   | 0_001011|
+------------+-------+-------+-------+--------+--------+
```

### Proposed funct7/funct3 map (covers all 10 ops)

> **If your single‑cycle used a different map, replace this table to match it.**

| Instruction | Semantics (RV32)                | funct7   | funct3 | Notes                                        |
|-------------|----------------------------------|----------|--------|----------------------------------------------|
| ANDN        | `rd = rs1 & ~rs2`               | 0000000  | 010    |                                              |
| ORN         | `rd = rs1 \| ~rs2`              | 0000001  | 010    | shares funct3 with ANDN                      |
| XNOR        | `rd = ~(rs1 ^ rs2)`             | 0000000  | 110    |                                              |
| MIN         | `rd = (s32)min(rs1,rs2)`        | 0000000  | 000    | signed compare                               |
| MAX         | `rd = (s32)max(rs1,rs2)`        | 0000001  | 000    |                                              |
| MINU        | `rd = (u32)min(rs1,rs2)`        | 0000000  | 001    | unsigned compare                             |
| MAXU        | `rd = (u32)max(rs1,rs2)`        | 0000001  | 001    |                                              |
| ROL         | `rd = (rs1 << (rs2&31)) | (rs1 >> (32-(rs2&31)))` | 0000000 | 101 | rotate left                                  |
| ROR         | `rd = (rs1 >> (rs2&31)) | (rs1 << (32-(rs2&31)))` | 0000001 | 101 | rotate right                                 |
| ABS         | `rd = (rs1[31]? -rs1 : rs1)`    | 0000000  | 111    | **rs2 must be 00000**                        |

- All bit fields are shown as binary; tooling may accept hex.  
- This map fits 10 ops with **no conflict** inside CUSTOM‑0.

#### Example encodings (binary → hex)

Let `rd=x3, rs1=x1, rs2=x2` (`rd=00011, rs1=00001, rs2=00010`).

- **ANDN x3,x1,x2**  
  `funct7=0000000, rs2=00010, rs1=00001, funct3=010, rd=00011, opcode=0001011`  
  Bits: `0000000_00010_00001_010_00011_0001011` → **0x04010**? (assembler will pack to 32b; see note below)

> **Note:** When authoring `.hex`, write the fully packed 32‑bit word. If you do not use an assembler, compute:
>
> `word = (funct7<<25) | (rs2<<20) | (rs1<<15) | (funct3<<12) | (rd<<7) | opcode`

A short Python helper to produce words for tests:

```python
def rvx10(custom_func7, funct3, rd, rs1, rs2):
    opcode = 0b0001011
    return (custom_func7<<25) | (rs2<<20) | (rs1<<15) | (funct3<<12) | (rd<<7) | opcode
```

---

## 3) Pseudocode Semantics (for spec & testbench assertions)

- **ANDN**: `rd ← rs1 & ~rs2`
- **ORN**: `rd ← rs1 | ~rs2`
- **XNOR**: `rd ← ~(rs1 ^ rs2)`
- **MIN**: `rd ← (int32)rs1 < (int32)rs2 ? rs1 : rs2`
- **MAX**: `rd ← (int32)rs1 > (int32)rs2 ? rs1 : rs2`
- **MINU**: `rd ← (uint32)rs1 < (uint32)rs2 ? rs1 : rs2`
- **MAXU**: `rd ← (uint32)rs1 > (uint32)rs2 ? rs1 : rs2`
- **ROL**: `sh ← rs2 & 31; rd ← (rs1<<sh) | (rs1>>(32-sh))`
- **ROR**: `sh ← rs2 & 31; rd ← (rs1>>sh) | (rs1<<(32-sh))`
- **ABS**: `rd ← (rs1[31]==1) ? (~rs1+1) : rs1` (two’s complement)

---

## 4) Branch, Load/Store, and Imm Encodings (RV32I quick table)

| Class     | Opcode    | Funct3 / Notes                                   |
|-----------|-----------|---------------------------------------------------|
| Loads     | 0000011   | `LB(000) LH(001) LW(010) LBU(100) LHU(101)`      |
| Stores    | 0100011   | `SB(000) SH(001) SW(010)`                         |
| Branches  | 1100011   | `BEQ(000) BNE(001) BLT(100) BGE(101) BLTU(110) BGEU(111)` |
| ALU‑imm   | 0010011   | `ADDI(000) SLTI(010) SLTIU(011) XORI(100) ORI(110) ANDI(111); SLLI(001) SRLI(101) SRAI(101 w/ imm[11:5]=0100000)` |
| ALU‑reg   | 0110011   | `ADD/SUB(000 w/ funct7=0000000/0100000), SLL(001), SLT(010), SLTU(011), XOR(100), SRL/SRA(101), OR(110), AND(111)` |
| Upper‑imm | 0110111   | `LUI`                                             |
| PC‑rel    | 0010111   | `AUIPC`                                           |
| Jumps     | 1101111   | `JAL`                                             |
| Indirect  | 1100111   | `JALR` (I‑type)                                   |

---

## 5) Assembler Hints / `.hex` Generation

- If you don’t have a custom assembler, encode RVX10 words with the helper formula above and dump as 8‑digit hex words in little‑endian memory order expected by your IMEM loader (see your testbench).
- For RV32I, you may assemble with `riscv64-unknown-elf-` tools and then post‑process ELF → “verilog” hex (one 32b word per line).

---

## 6) Compatibility Notes

- The **Hazard/Forwarding** units treat RVX10 like any R‑type ALU op (writeback in WB, bypass from EX/MEM and MEM/WB as needed).
- **ABS** uses `rs2=0` convention to keep R‑type form; the decode must ignore `rs2` for ABS.
- Ensure **writes to `x0` are dropped** (architectural zero).

---

## 7) Revision Control

- Keep this file at `/docs/Encoding.md` and version it with your RTL and tests.
