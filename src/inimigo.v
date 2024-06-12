module inimigo(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] xi,
    input [9:0] yi,
    output reg [9:0] x,    
    output reg [9:0] y, 
    input [9:0] x_bola_nave, 
    input [9:0] y_bola_nave, 
    output reg vivo,
);
    reg clk;
    reg [32:0] contador;
    reg [32:0] divisorCLK;
    reg sentidoX;
    reg [9:0] largura;
    reg [9:0] altura;

    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50) begin //divisor de clock
        if (contador >= 320000) begin 
            contador = 0;
            clk = ~clk;
        end else begin
            contador = contador + 1;
        end
    end 

    always @(posedge CLOCK_50) begin
        if (reset) begin
            vivo = 1;
        end else begin
            if ((x < x_bola_nave) && (x_bola_nave < x + largura) && (y < y_bola_nave) && (y_bola_nave < y + altura)) begin
                vivo = 0;
            end
        end
    end


    always @(posedge clk or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = xi;
            y = yi;
            sentidoX = 0;
            largura = 33;
            altura = 24;
        end else if (pausa == 0) begin
            if (x > 640 || x + largura > 640) begin // abaixa
                y = y + 20;
                sentidoX = ~sentidoX;
            end
            if(sentidoX) begin // direita
                x = x + 2;
            end else begin // esquerda
                x = x - 2;
            end

        end
    end


endmodule
