module inimigo(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,

    input [9:0] xi,
    input [9:0] yi,
    
    input [9:0] largura,
    input wire [9:0] altura, 
    output reg [9:0] x,    
    output reg [9:0] y, 

    input [9:0] bola_nave_x, 
    input [9:0] bola_nave_y, 
  
    output reg vivo,
    output [9:0] LEDR

);
    reg clk;
    reg [32:0] contador;
    reg [32:0] divisorCLK;
    reg sentidoX;

    assign resetInimigo = reset || reiniciarJogo;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 320000) begin 
            contador = 0;
            clk = ~clk;
        end
    end 
    //(bola_nave_y < (y + altura))

    assign LEDR = altura;
    // assign vivo = (bola_nave_y > y) && (y > (bola_nave_y - altura)) == 1'b1 ? 1'b1 : 1'b0;

    always @(posedge CLOCK_50) begin
        if (reset) begin
            vivo = 1;
            //LEDR[0] = 0;
        end else begin
            if ((x < bola_nave_x) && (bola_nave_x < x + 33) && (y < bola_nave_y) && (bola_nave_y < y + 24)) begin
            // if ((bola_nave_y > y) && (y > (bola_nave_y - 24))) begin
                //LEDR[0] = 1;
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
            if (x - largura > 640 || x + 33 > 640) begin // abaixa
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
