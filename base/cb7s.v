module cb7s (
    input clk,
    input [3:0] entrada,
    output reg [6:0] saida
);

//0000 -> 1111110 -> 0
//0001 -> 0110000 -> 1
//0010 -> 1101101 -> 2
//0011 -> 1111001 -> 3
//0100 -> 0110011 -> 4
//0101 -> 1011101 -> 5
//0110 -> 1011111 -> 6
//0111 -> 1110000 -> 7
//1000 -> 1111111 -> 8
//1001 -> 1111011 -> 9

always @ (posedge clk) begin
    if (entrada == 0) begin
        saida <= ~7'b0111111;
    end if (entrada == 1) begin
        saida <= ~7'b0000110;
    end if (entrada == 2) begin
        saida <= ~7'b1011011;
    end if (entrada == 3) begin
        saida <= ~7'b1001111;
    end if (entrada == 4) begin
        saida <= ~7'b1100110;
    end if (entrada == 5) begin
        saida <= ~7'b1101101;
    end if (entrada == 6) begin
        saida <= ~7'b1111101;
    end if (entrada == 7) begin
        saida <= ~7'b0000111;
    end if (entrada == 8) begin
        saida <= ~7'b1111111;
    end if (entrada == 9) begin
        saida <= ~7'b1101111;
    end
end

endmodule