module random_pulse_generator (
    input clk,          // Clock input
    input rst_n,        // Active low reset
    output pulse       // Random pulse output
);

    reg [15:0] counter;  // Counter to control pulse generation
    reg [15:0] random_value; // Random value
    reg pulse_reg;      // Register to hold pulse output

    // Simple Linear Feedback Shift Register (LFSR) for randomness
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 16'b0;
            random_value <= 16'b1;  // Seed the random value
            pulse_reg <= 0;
        end else begin
            counter <= counter + 1;

            // Simple 16-bit LFSR to generate randomness
            random_value <= {random_value[14:0], random_value[15] ^ random_value[13] ^ random_value[12] ^ random_value[10]};

            // Compare counter with random value to generate pulses at random intervals
            if (counter >= random_value) begin
                pulse_reg <= 1;
                counter <= 16'b0;  // Reset the counter after a pulse
            end else begin
                pulse_reg <= 0;
            end
        end
    end

    assign pulse = pulse_reg;  // Output the generated pulse

endmodule
