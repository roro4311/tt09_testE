`timescale 1ns/1ps

module tb;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;
    reg ena;

    // Instantiate the top-level module
    tt_um_morse_code dut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in),
        .ena(ena)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // VCD dump logic
    initial begin
        $dumpfile("dump.vcd");    // Specify the name of the VCD file
        $dumpvars(0, tb);         // Dump all variables in the tb module
    end

    // Simulation logic
    initial begin
        // Initialize inputs
        rst_n = 0;
        ui_in = 8'b0;
        uio_in = 8'b0;
        ena = 1'b1;

        // Reset the design
        #10 rst_n = 1;

        // Simulate Morse code for "A" (.-)

        // Dot (short press)
        ui_in[0] = 1'b1;          // Button pressed
        #100_000;                 // Hold for 100_000 ns (dot duration)
        ui_in[0] = 1'b0;          // Button released
        #100_000;                 // Wait 1 dot duration between symbols within a letter

        // Dash (long press)
        ui_in[0] = 1'b1;          // Button pressed
        #300_000;                 // Hold for 300_000 ns (dash duration)
        ui_in[0] = 1'b0;          // Button released
        #300_000;                 // Wait 3 dot durations after character entry

        // End simulation
        #1_000_000;
        $finish;
    end
endmodule
