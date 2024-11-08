module morse_decoder_combined (
    input wire clk,
    input wire rst_n,
    input wire button,
    output reg [7:0] decoded_char
);

    // Morse signal encoding: 00 = no input, 01 = dot, 10 = dash
    reg [1:0] morse_signal;
    reg [5:0] morse_seq;    // Sequence of dots/dashes (up to 6 bits)
    reg [31:0] counter;     // To measure button press duration
    reg button_released;    // Track if button was released

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_signal <= 2'b00;
            morse_seq <= 6'b0;
            decoded_char <= 8'b0;
            counter <= 32'b0;
            button_released <= 1'b1;
        end else begin
            // Button Input Logic
            if (button) begin
                counter <= counter + 1;       // Increment counter while button is pressed
                button_released <= 1'b0;      // Button is held down
            end else if (!button && !button_released) begin
                // Button released: determine dot or dash
                if (counter >= 2000)
                    morse_signal <= 2'b10;  // Dash
                else if (counter >= 100)
                    morse_signal <= 2'b01;  // Dot
                else
                    morse_signal <= 2'b00;  // Invalid press (reset signal)

                // Shift morse_seq with new dot/dash
                if (morse_signal != 2'b00) begin
                    morse_seq <= {morse_seq[4:0], morse_signal[0]};
                    $display("Captured Morse Sequence: %b", morse_seq);
                end

                // Decode morse_seq into character
                case (morse_seq)
                    6'b01_00_00: decoded_char <= "A";  // .-
                    6'b10_00_00: decoded_char <= "B";  // -...
                    6'b10_10_00: decoded_char <= "C";  // -.-.
                    6'b10_01_00: decoded_char <= "D";  // -..
                    6'b00_00_00: decoded_char <= "E";  // .
                    6'b01_10_00: decoded_char <= "F";  // ..-.
                    6'b10_10_10: decoded_char <= "G";  // --.
                    6'b01_01_00: decoded_char <= "H";  // ....
                    6'b01_00_00: decoded_char <= "I";  // ..
                    6'b01_11_11: decoded_char <= "J";  // .---
                    6'b10_01_10: decoded_char <= "K";  // -.-
                    6'b01_10_01: decoded_char <= "L";  // .-..
                    6'b10_10_00: decoded_char <= "M";  // --
                    6'b10_00_00: decoded_char <= "N";  // -.
                    6'b10_10_10: decoded_char <= "O";  // ---
                    6'b01_11_10: decoded_char <= "P";  // .--.
                    6'b10_10_01: decoded_char <= "Q";  // --.-
                    6'b01_10_00: decoded_char <= "R";  // .-.
                    6'b01_01_00: decoded_char <= "S";  // ...
                    6'b10_00_00: decoded_char <= "T";  // -
                    6'b01_01_10: decoded_char <= "U";  // ..-
                    6'b01_01_01: decoded_char <= "V";  // ...-
                    6'b01_11_00: decoded_char <= "W";  // .--
                    6'b10_01_01: decoded_char <= "X";  // -..-
                    6'b10_01_11: decoded_char <= "Y";  // -.--
                    6'b10_10_01: decoded_char <= "Z";  // --..
                    default: decoded_char <= 8'h00;    // Unknown
                endcase

                // Reset sequence after decoding a character
                if (decoded_char != 8'h00) begin
                    morse_seq <= 6'b0;
                end

                // Reset for next button press
                counter <= 32'b0;
                button_released <= 1'b1;
                morse_signal <= 2'b00;
            end else begin
                morse_signal <= 2'b00;  // No input when button is not pressed
            end
        end
    end
endmodule
