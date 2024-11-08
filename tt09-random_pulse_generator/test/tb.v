`timescale 1ns/1ps

// tb.v - Testbench for tt_um (Random Pulse Generator)
module tb;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg ena;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg [7:0] uio_in;

    // Instantiate the tt_um module
    tt_um_random_pulse_generator uut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(uio_in)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Generate a clock with a period of 10 time units
    end

    // Initial block to apply stimulus
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        ena = 0;
        uio_in = 8'b0;

        // Apply reset
        #10 rst_n = 1;    // Release reset after 10 time units
        #10 ena = 1;      // Enable pulse generation

        // Test case: Generate pulses for 100 time units
        #100 ena = 0;     // Disable pulse generation
        #50 ena = 1;      // Re-enable pulse generation
        #100 $finish;     // End the simulation
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t, Pulse = %b", $time, uio_out[0]);
    end

endmodule
