module inimigo(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    
    output reg [9:0] largura,
    output reg [9:0] altura,
    output reg [9:0] x,
    output reg [9:0] y

);
    wire resetInimigo;
    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50 or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = 300;
            y = 300;
            largura = 11;
            altura = 8;
        end
    end

endmodule