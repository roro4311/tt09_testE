module tt_um_reaction_timer (
    input wire clk,
    input wire rst_n,
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire [7:0] uio_in,
    input wire ena
);

    wire [7:0] reaction_time;
    wire spi_clk;
    wire spi_mosi;
    wire spi_cs;
    wire spi_miso;
    wire [6:0] seg1, seg2, seg3, seg4;

    // Assuming ui_in[0] is the button and ui_in[1] is the LED indicator
    wire button = ui_in[0];
    wire led_on = ui_in[1];

    // Instantiate the Reaction Timer module
    reaction_timer reaction_timer_inst (
        .clk(clk),
        .rst_n(rst_n),
        .button(button),
        .led_on(led_on),
        .time_out(reaction_time)
    );

    // Instantiate the SPI module
    spi_driver spi_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in({24'b0, reaction_time}), // Pad reaction_time to 32 bits
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_cs(spi_cs)
    );

    // Instantiate the Display Controller
    display_controller display_inst (
        .clk(clk),
        .reset(!rst_n),
        .reaction_time(reaction_time),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .seg4(seg4)
    );

    // Outputs handling
    assign uo_out = 8'b0;  // Default uo_out to 0
    assign uio_out = (ena) ? {seg4, seg3, seg2, seg1} : 8'b0; // Concatenate the segments
    assign uio_oe = 8'b11111111; // Set all as outputs

    // Debugging
    initial begin
        $monitor("At time %t, ui_in = %h, spi_mosi = %b, spi_clk = %b, spi_cs = %b, reaction_time = %h, uo_out = %h, uio_out = %h, uio_oe = %h", 
                 $time, ui_in, spi_mosi, spi_clk, spi_cs, reaction_time, uo_out, uio_out, uio_oe);
    end

endmodule

