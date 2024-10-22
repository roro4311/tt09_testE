module display_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] reaction_time,
    output wire [6:0] seg1,
    output wire [6:0] seg2,
    output wire [6:0] seg3,
    output wire [6:0] seg4
);

    wire [3:0] digit1 = reaction_time % 10;
    wire [3:0] digit2 = (reaction_time / 10) % 10;
    wire [3:0] digit3 = (reaction_time / 100) % 10;
    wire [3:0] digit4 = (reaction_time / 1000) % 10;

    seven_segment seg1_inst (
        .digit(digit1),
        .seg(seg1)
    );

    seven_segment seg2_inst (
        .digit(digit2),
        .seg(seg2)
    );

    seven_segment seg3_inst (
        .digit(digit3),
        .seg(seg3)
    );

    seven_segment seg4_inst (
        .digit(digit4),
        .seg(seg4)
    );

endmodule

