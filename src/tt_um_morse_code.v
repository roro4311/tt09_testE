module tt_um_morse_code (
    input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire [7:0] uio_in,
    input wire ena
);
    // Internal signals
    wire [1:0] morse_signal;
    wire [7:0] decoded_char;
    wire [6:0] seg;

    // Button input logic (ui_in[0] used for button input)
    button_input button_inst (
        .clk(clk),
        .rst_n(rst_n),
        .button(ui_in[0]),
        .morse_signal(morse_signal)
    );

    // Morse code decoder logic
    morse_decoder decoder_inst (
        .clk(clk),
        .rst_n(rst_n),
        .morse_signal(morse_signal),
        .decoded_char(decoded_char)
    );

    // Seven-segment display logic
    seven_segment_display display_inst (
        .char(decoded_char[7:0]), // Ensure 8-bit input
        .seg(seg)
    );

    // Outputs
    assign uo_out = 8'b0; // Not used in this project
    assign uio_out = {1'b0, seg}; // Only 7 bits are used for the 7-segment display
    assign uio_oe = 8'b11111111; // Output enable all bits

endmodule