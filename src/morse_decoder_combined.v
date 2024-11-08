module morse_decoder_combined (
    input wire clk,
    input wire rst_n,
    input wire button,
    output reg [7:0] decoded_char
);

    // Morse signal encoding: 0 = no input, 1 = dot, 2 = dash
    reg [5:0] morse_seq;         // Sequence of dots/dashes (up to 6 bits)
    reg [31:0] counter;          // To measure button press duration
    reg [31:0] gap_counter;      // To measure gap duration after button release
    reg button_released;         // Track if button was released
    reg new_char;                // Signal indicating new character detected

    // Morse code timing parameters (adjust as needed)
    parameter DOT_DURATION = 2000;
    parameter DASH_DURATION = 3 * DOT_DURATION;
    parameter INTER_ELEMENT_GAP = DOT_DURATION;
    parameter LETTER_GAP = 3 * DOT_DURATION;
    parameter WORD_GAP = 7 * DOT_DURATION;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_seq <= 6'b0;
            decoded_char <= 8'b0;
            counter <= 32'b0;
            gap_counter <= 32'b0;
            button_released <= 1'b1;
            new_char <= 1'b0;
        end else begin
            // Button Press Logic
            if (button) begin
                counter <= counter + 1;   // Increment counter while button is pressed
                gap_counter <= 32'b0;     // Reset gap counter during press
                button_released <= 1'b0;
            end else if (!button && !button_released) begin
                // Button released; determine dot or dash
                if (counter >= DASH_DURATION) begin
                    morse_seq <= {morse_seq[4:0], 1'b0};  // Dash (0)
                end else if (counter >= DOT_DURATION) begin
                    morse_seq <= {morse_seq[4:0], 1'b1};  // Dot (1)
                end

                // Display captured sequence for debugging
                $display("Captured Morse Sequence: %b", morse_seq);

                // Reset button tracking and counter
                counter <= 32'b0;
                button_released <= 1'b1;
            end else if (button_released) begin
                // Button is not pressed; count gap duration
                gap_counter <= gap_counter + 1;

                // Detect end of letter or word based on gap duration
                if (gap_counter >= LETTER_GAP && gap_counter < WORD_GAP) begin
                    // Letter gap detected; ready to decode
                    new_char <= 1'b1;
                end else if (gap_counter >= WORD_GAP) begin
                    // Word gap detected; reset sequence
                    morse_seq <= 6'b0;
                    new_char <= 1'b0;
                end else begin
                    new_char <= 1'b0;
                end
            end

            // Decode morse_seq into character
            if (new_char) begin
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

                // Reset sequence and new_char flag after decoding
                morse_seq <= 6'b0;
                new_char <= 1'b0;
            end
        end
    end
endmodule
