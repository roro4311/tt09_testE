module spi_driver (
    input wire clk,
    input wire rst_n,
    input wire [31:0] data_in,
    output wire spi_clk,
    output wire spi_mosi,
    input wire spi_miso,
    output wire spi_cs
);

    reg [31:0] data_reg;
    reg [4:0] bit_counter;
    reg spi_clk_reg, spi_mosi_reg, spi_cs_reg;

    assign spi_clk = spi_clk_reg;
    assign spi_mosi = spi_mosi_reg;
    assign spi_cs = spi_cs_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 32'd0;
            bit_counter <= 5'd0;
            spi_clk_reg <= 1'b0;
            spi_mosi_reg <= 1'b0;
            spi_cs_reg <= 1'b1;
        end else begin
            spi_cs_reg <= 1'b0;
            if (bit_counter < 5'd32) begin
                spi_clk_reg <= ~spi_clk_reg;
                if (spi_clk_reg) begin
                    spi_mosi_reg <= data_reg[31];
                    data_reg <= {data_reg[30:0], spi_miso};
                    bit_counter <= bit_counter + 1;
                end
            end else begin
                spi_cs_reg <= 1'b1;
            end
        end
    end

endmodule

