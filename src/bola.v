module bola(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] xi,
    input [9:0] yi,
    input ehAliada,
    input iniciar_movimento,
    output reg bateu,
    output reg [9:0] x,
    output reg [9:0] y,
    output [9:0] raio,
    input [9:0] larguraAtirador
);
    reg clk;
    reg movimentar;
    reg [32:0] contador;
    assign raio = 5;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 200000) begin 
            contador = 0;
            clk = ~clk;
        end 
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x = 1000;
            y = 1000;
            bateu = 0;
            movimentar = 0;
        end else if (pausa == 0) begin
            if (iniciar_movimento && !movimentar) begin
                x = xi + (larguraAtirador) / 2 ;
                y = yi + 35;
                movimentar = 1;
                bateu = 0;
            end
            if (movimentar) begin
                if (ehAliada) begin
                    y = y - 5;
                end else begin
                    y = y + 5;
                end

                if (y <= 0) begin
                    bateu = 1;
                    movimentar = 0;
                    x = 1000;
                    y = 1000;
                end
            end

        end
    end
endmodule