module seven_segment_display (
    input wire [7:0] char,   // ASCII character input
    output reg [6:0] seg     // 7-segment output
);

   always @(*) begin
    case (char)
        "A": seg = 7'b0111111;  // A
        "B": seg = 7'b0000111;  // B
        "C": seg = 7'b1001110;  // C
        "D": seg = 7'b0111101;  // D
        "E": seg = 7'b1001111;  // E
        "F": seg = 7'b1000111;  // F
        "G": seg = 7'b1011110;  // G
        "H": seg = 7'b0110111;  // H
        "I": seg = 7'b0110000;  // I
        "J": seg = 7'b0111100;  // J
        "K": seg = 7'b0110111;  // K (same as H, limited by 7-segment constraints)
        "L": seg = 7'b0001110;  // L
        "M": seg = 7'b1110110;  // M (approximation)
        "N": seg = 7'b0101011;  // N (approximation)
        "O": seg = 7'b1111110;  // O
        "P": seg = 7'b1100111;  // P
        "Q": seg = 7'b1110011;  // Q (approximation)
        "R": seg = 7'b0000101;  // R (approximation)
        "S": seg = 7'b1011011;  // S
        "T": seg = 7'b0001111;  // T
        "U": seg = 7'b0111110;  // U
        "V": seg = 7'b0011100;  // V (approximation)
        "W": seg = 7'b0011010;  // W (approximation)
        "X": seg = 7'b0110111;  // X (approximation, same as H)
        "Y": seg = 7'b0111011;  // Y
        "Z": seg = 7'b1101101;  // Z
        default: seg = 7'b0000000;  // Blank display for unsupported chars
    endcase
end


endmodule
