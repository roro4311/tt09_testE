module tb;
    reg clk;
    reg rst_n;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg ena;

    // Instantiate the tt_um_morse_code module
    tt_um_morse_code uut (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .uio_in(8'b0), // No input from uio_in for this test
        .ena(ena)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period (100 MHz)
    end

    // Test sequence
    initial begin
        // Initialize
        rst_n = 0;
        ui_in = 8'b0;
        ena = 1;
        #20 rst_n = 1;

        // Morse code for "A" (dot-dash): Dot (100 ns), 1-dot gap, Dash (300 ns)
        // Dot press
        ui_in[0] = 1;        // Simulate button press for dot
        #100 ui_in[0] = 0;   // Release button
        #100;                // Element gap (1 dot duration)

        // Dash press
        ui_in[0] = 1;        // Simulate button press for dash
        #300 ui_in[0] = 0;   // Release button
        #700;                // Word gap (7 dots) to end character

        // End of simulation
        #1000 $stop;
    end
endmodule
