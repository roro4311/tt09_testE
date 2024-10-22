`default_nettype none
`timescale 1ns / 1ps

module reaction_timer (
    input wire clk,            // Clock signal
    input wire rst_n,          // Active-low reset
    input wire button,         // Button input
    input wire led_on,         // LED indicator (high when LED lights up)
    output reg [7:0] time_out  // Reaction time output
);

    // Internal registers for state and count
    reg [7:0] count;
    reg button_prev;
    reg counting;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 8'b0;
            time_out <= 8'b0;
            button_prev <= 1'b0;
            counting <= 1'b0;
        end else begin
            if (led_on && !counting) begin
                // LED lights up and counting is not already started
                counting <= 1'b1;
                count <= 8'b0;  // Reset the count when starting
            end else if (counting) begin
                if (button && !button_prev) begin
                    // Button pressed while counting
                    time_out <= count;
                    counting <= 1'b0;  // Stop counting
                end else if (!led_on) begin
                    // LED is off and counting is active
                    time_out <= count;  // Output the count when stopping
                    counting <= 1'b0;   // Stop counting
                end else begin
                    // Increment count while counting
                    count <= count + 1;
                end
            end

            // Store the previous button state
            button_prev <= button;
        end
    end

endmodule

