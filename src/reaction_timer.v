module reaction_timer (
    input wire clk,
    input wire rst_n,
    input wire button,
    input wire led_on,
    output reg [7:0] time_out
);

    reg [7:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'd0;
            time_out <= 8'd0;
        end else if (led_on) begin
            counter <= counter + 1;
        end else if (button) begin
            time_out <= counter;
            counter <= 8'd0;
        end else begin
            counter <= counter;
        end
    end

endmodule

