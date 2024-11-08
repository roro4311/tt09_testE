// tt_um.v - Random Pulse Generator Wrapper Module
module tt_um_random_pulse_generator (
    input wire clk,           // Clock input
    input wire rst_n,         // Active low reset
    input wire ena,           // Enable signal
    output wire [7:0] uo_out, // Output (not used in this project, set to 0)
    output wire [7:0] uio_out, // Output for pulse signal (1 bit used for the pulse)
    output wire [7:0] uio_oe,  // Output enable signal (for uio_out)
    input wire [7:0] uio_in    // Input (unused in this design, can be set to 0)
);

    // Internal signal for pulse output from the random_pulse_generator module
    wire pulse;

    // Instantiate the random_pulse_generator module
    random_pulse_generator pulse_gen_inst (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .pulse(pulse)
    );

    // Output assignments
    assign uo_out = 8'b0;             // Not used in this project, always 0
    assign uio_out = {7'b0, pulse};   // Only 1 bit used for the pulse output (LSB)
    assign uio_oe = 8'b11111111;      // Output enable all bits

endmodule
