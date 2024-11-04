module button_input (
    input wire clk,
    input wire rst_n,
    input wire button,
    output reg [1:0] morse_signal, // 00: no input, 01: dot, 10: dash
    output reg letter_spacing       // 1 when letter space is detected
);

    reg [31:0] counter;             // To measure button press duration
    reg [31:0] spacing_counter;     // To measure gap duration after release
    reg button_released;            // Track if the button was released
    reg detecting_gap;              // Track if gap detection is ongoing

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_signal <= 2'b00;
            counter <= 32'b0;
            spacing_counter <= 32'b0;
            button_released <= 1'b1;     // Initialize as "released"
            detecting_gap <= 1'b0;
            letter_spacing <= 1'b0;
        end else begin
            if (button) begin
                // Button pressed; increment counter for press duration
                counter <= counter + 1;
                button_released <= 1'b0;
                detecting_gap <= 1'b0;
                spacing_counter <= 32'b0;
                letter_spacing <= 1'b0;  // Reset letter spacing signal
            end else if (!button && !button_released) begin
                // Button released; determine if it's a dot or dash
                if (counter >= 2000)  // Dash threshold
                    morse_signal <= 2'b10;  // Dash
                else if (counter >= 100) // Adjust lower threshold for dot
                    morse_signal <= 2'b01;  // Dot
                else
                    morse_signal <= 2'b00;  // No valid input

                // Reset counter for next press and start gap detection
                counter <= 32'b0;
                button_released <= 1'b1;
                detecting_gap <= 1'b1;
            end else if (detecting_gap) begin
                // Gap detection mode
                spacing_counter <= spacing_counter + 1;

                // Identify the spacing duration
                if (spacing_counter >= 3000) begin  // Letter spacing threshold
                    letter_spacing <= 1'b1;  // Set letter spacing flag
                    morse_signal <= 2'b00;   // Clear signal after space
                    detecting_gap <= 1'b0;   // End gap detection
                end else if (spacing_counter >= 1000) begin  // Dot-dash gap threshold
                    morse_signal <= 2'b00;   // Clear signal after symbol gap
                end
            end else begin
                // No input when button is not pressed or spacing is detected
                morse_signal <= 2'b00;
            end
        end
    end
endmodule
