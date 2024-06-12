module inimigo(
    input CLOCK_50,
    input CLOCK_MV,
    input reset,
    input pausa,
    input reiniciarJogo,

    input [9:0] xi,
    input [9:0] yi,
    
    output reg [9:0] x,    
    output reg [9:0] y, 

    input [9:0] bola_nave_x, 
    input [9:0] bola_nave_y, 
    
    input sentidoX,
    output reg vivo
);
    reg [32:0] divisorCLK;

    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50) begin
        if (reset) begin
            vivo = 1;
        end else begin
            if ((x < bola_nave_x) && (bola_nave_x < x + 33) && (y < bola_nave_y) && (bola_nave_y < y + 24)) begin
                vivo = 0;
            end
        end
    end

    reg [9:0] largura;

    always @(posedge CLOCK_MV or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = xi;
            y = yi;
            largura = 33;
        end else begin
            if (pausa == 0) begin
                if (x < 20 || x + 33 > 640) begin // abaixa
                    y = y + 20;
                end
                if(sentidoX) begin // direita
                    x = x + 2;
                end else begin // esquerda
                    x = x - 2;
                end
            end
        end
    end

endmodule
