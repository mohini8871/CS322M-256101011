// link_top.v
// Connects master_fsm and slave_fsm together on a shared clk/rst.
module link_top (
    input  wire clk,
    input  wire rst,
    output wire done
);
    // Wires between master and slave
    wire        req_w;
    wire        ack_w;
    wire [7:0]  data_w;
    wire [7:0]  last_byte_w;

    master_fsm u_master (
        .clk (clk),
        .rst (rst),
        .ack (ack_w),
        .req (req_w),
        .data(data_w),
        .done(done)
    );

    slave_fsm u_slave (
        .clk      (clk),
        .rst      (rst),
        .req      (req_w),
        .data_in  (data_w),
        .ack      (ack_w),
        .last_byte(last_byte_w)
    );

    // Optional: expose some internal signals via hierarchical paths in TB.
endmodule
