module inimigo(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    
    output wire [9:0] largura,
    output wire [9:0] altura,
    output reg [9:0] x,
    output reg [9:0] y

);

    assign largura = 30;
    assign altura = 30;
    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50 or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = 300;
            y = 300;
        end else if (pausa == 0) begin

        end
    end

endmodule