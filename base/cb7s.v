module cb7s (
    input clk,
    input [3:0] entrada,
    output reg [6:0] saida
);
    always @ (posedge clk) begin
        if (entrada == 0) begin
            saida <= ~7'b0111111;
        end else if (entrada == 1) begin
            saida <= ~7'b0000110;
        end else if (entrada == 2) begin
            saida <= ~7'b1011011;
        end else if (entrada == 3) begin 
            saida <= ~7'b1001111;
        end else if (entrada == 4) begin
            saida <= ~7'b1100110;
        end else if (entrada == 5) begin
            saida <= ~7'b1101101;
        end else if (entrada == 6) begin
            saida <= ~7'b1111101;
        end else if (entrada == 7) begin
            saida <= ~7'b0000111;
        end else if (entrada == 8) begin
            saida <= ~7'b1111111;
        end else if (entrada == 9) begin
            saida <= ~7'b1101111;
        end else if (entrada == 10) begin 
            saida <= ~7'b1110111;
        end else if (entrada == 11) begin 
            saida <= ~7'b1111100;
        end else if (entrada == 12) begin 
            saida <= ~7'b0111001;
        end else if (entrada == 13) begin 
            saida <= ~7'b1011110;
        end else if (entrada == 14) begin 
            saida <= ~7'b1111001;
        end else if (entrada == 15) begin 
            saida <= ~7'b1110001;
        end
    end

endmodule