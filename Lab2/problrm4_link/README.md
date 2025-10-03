# Problem 4 — Master–Slave Link (req/ack, 8-bit data)

This directory implements a two-FSM handshake link per the CS322M assignment:

- `master_fsm.v`: Drives a 4-byte burst over an 8‑bit data bus using a 4‑phase req/ack handshake. Pulses `done` after the final byte.
- `slave_fsm.v`: Latches `data_in` when `req` is asserted, holds `ack` high for **2 cycles**, then waits for `req` to drop before deasserting `ack`.
- `link_top.v`: Wires master and slave together.
- `tb_link_top.v`: Self-checking testbench that dumps waveforms and prints the received sequence.

## Handshake timing (per byte)

1. Master drives `data` and raises `req`  
2. Slave samples `data` on seeing `req=1` and raises `ack` (kept high for **2 cycles**)  
3. Master sees `ack`, then lowers `req`  
4. Slave, after the 2-cycle hold window, lowers `ack` once `req=0`  
5. Repeat for 4 bytes, then master pulses `done` (1 cycle)

## How to run (Icarus Verilog + GTKWave)

```bash
# From this directory
iverilog -g2012 -o sim.out tb_link_top.v link_top.v master_fsm.v slave_fsm.v
vvp sim.out
gtkwave dump.vcd &
```

Expected console output includes 4 ack events and a DONE message. In GTKWave, inspect:
- `dut.u_master.{req,data,done,state,idx}` (state/idx visible if you expand the instance)
- `dut.u_slave.{ack,last_byte,state,hold_cnt}`
- The sequence should be `A0, A1, A2, A3`, and `done` pulses one cycle after the last transaction.

## Notes

- All logic uses **synchronous, active-high** reset.  
- The slave holds `ack` for **two full clock cycles**, satisfying the spec requirement.  
- The master does not proceed to the next byte until it has observed `ack` and has dropped `req` accordingly.
