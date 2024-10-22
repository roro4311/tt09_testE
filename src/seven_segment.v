module seven_segment_display (
    input wire [7:0] char,   // ASCII character input
    output reg [6:0] seg     // 7-segment output
);

    always @(*) begin
        case (char)
            "A": seg = 7'b0111111;
            "B": seg = 7'b0000111;
            "C": seg = 7'b1001110;
            "D": seg = 7'b0111101;
            "E": seg = 7'b1001111;
            "F": seg = 7'b1000111;
            // Add all relevant characters for display...
            default: seg = 7'b0000000; // Blank display for unsupported chars
        endcase
    end

endmodule
