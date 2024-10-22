module button_input (
    input wire clk,
    input wire rst_n,
    input wire button,
    output reg [1:0] morse_signal // 00: no input, 01: dot, 10: dash
);

    reg [31:0] counter;        // To measure button press duration
    reg button_released;       // Track if the button was released

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            morse_signal <= 2'b00;
            counter <= 32'b0;
            button_released <= 1'b1;  // Initialize as "released"
        end else begin
            if (button) begin
                counter <= counter + 1;       // Increment counter while button is pressed
                button_released <= 1'b0;      // Button is held down
            end else if (!button && !button_released) begin
                // Check if button was released after being pressed

                // Adjust the threshold based on clock cycles
                if (counter >= 2000)  // Dash threshold
                    morse_signal <= 2'b10;  // Dash
                else if (counter < 100) // Adjust lower threshold for dot
                    morse_signal <= 2'b01;  // Dot
                else
                    morse_signal <= 2'b00;  // No input (invalid press)

                // Reset for the next button press
                counter <= 32'b0;
                button_released <= 1'b1;  // Button is now released
            end else begin
                morse_signal <= 2'b00;  // No input while button is not pressed
            end
        end
    end

endmodule
