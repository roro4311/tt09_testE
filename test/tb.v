`timescale 1ns/1ps

module tb;

    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;
    reg ena;

    // Instantiate the DUT
    tt_um_reaction_timer dut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in),
        .ena(ena)
    );

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ui_in = 0;
        uio_in = 0;
        ena = 0;

        // Apply reset
        #10 rst_n = 1;

        // Test sequence
        #20 ui_in = 8'b00000010; // LED on
        #20 ui_in = 8'b00000000;
        #100 ui_in = 8'b00000001; // Button pressed
        #20 ui_in = 8'b00000000;

        // End simulation
        #200 $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule

