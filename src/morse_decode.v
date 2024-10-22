module morse_decoder (
    input wire clk,
    input wire rst_n,
    input wire [1:0] morse_signal,
    output reg [7:0] decoded_char
);

    reg [5:0] morse_seq;  // Sequence of dots/dashes (up to 6 bits)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_seq <= 6'b0;
            decoded_char <= 8'b0;
        end else begin
            // Update sequence with new dot/dash
            if (morse_signal == 2'b01 || morse_signal == 2'b10) begin
                morse_seq <= {morse_seq[4:0], morse_signal[0]};  // Shift sequence
            end

            // On space or end of sequence, decode the character
            case (morse_seq)
                6'b01_00_00: decoded_char <= "A";
                6'b10_00_00: decoded_char <= "B";
                6'b10_10_00: decoded_char <= "C";
                // ... Add all Morse code sequences here ...
                6'b00_00_00: decoded_char <= "E";
                6'b11_11_00: decoded_char <= "Z";
                default: decoded_char <= 8'h00;  // Unknown
            endcase
        end
    end

endmodule
