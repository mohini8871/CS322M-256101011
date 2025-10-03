# Problem 3:Vending Machine Mealy FSM


## File
- `vending_mealy.v` : Vending machine FSM implementation in Verilog.
- `tb_vending_mealy.v` : Testbench for the vending machine FSM.
- `README.md` : Documentation.

## Compile and Run
1. **Compile the code**:
    - Use your Verilog compiler (e.g., ModelSim, Vivado):
      ```bash
      vlog vending_mealy.v tb_vending_mealy.v
      ```
2. **Simulate the testbench**:
    - For ModelSim:
      ```bash
      vsim tb_vending_mealy
      run -all
      ```
3. **Visualize the waveform**:
    - Open the waveform viewer and check the outputs for `vend` and `chg5`.

## Expected Behavior
- When the total reaches 20, `vend` should output 1.
- When the total reaches 25, both `vend` and `chg5` should output 1.
- The state machine should reset after dispensing the product and change.

![waverform figure](wavefm.png)



![state daigram](fsm_daigram.jpg)