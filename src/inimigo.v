module inimigo(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,

    input [9:0] xi,
    input [9:0] yi,
    
    output wire [9:0] largura,
    output wire [9:0] altura,
    output reg [9:0] x,
    output reg [9:0] y,

    input [9:0] bola_nave_x,
    input [9:0] bola_nave_y,

    output reg vivo

);
    reg clk;
    reg [32:0] contador;
    reg [32:0] divisorCLK;
    reg sentidoX;

    assign largura = 33;
    assign altura = 24;
    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 25000000) begin 
            contador = 0;
            clk = ~clk;
        end
    end 

    always @(posedge CLOCK_50) begin
        if (reset) begin
            vivo = 1;
        end else begin
            if ((x < bola_nave_x) && (bola_nave_x < x + largura) && (y < bola_nave_y) && (bola_nave_y < y + altura)) begin
                vivo = 0;
            end
        end
    end

    always @(posedge clk or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = xi;
            y = yi;
            sentidoX = 0;
        end else if (pausa == 0) begin
            if (x <= 0 || x + largura >= 640) begin // abaixa
                y = y + 20;
                sentidoX = ~sentidoX;
            end
            if(sentidoX) begin // direita
                x = x + 20;
            end else begin // esquerda
                x = x - 20;
            end

        end
    end


endmodule
