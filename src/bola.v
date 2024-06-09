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
    output [9:0] raio
    // output [9:0] LEDR
);
    reg movimentar;
    assign raio = 5;

    reg [32:0] contador;
    reg [32:0] divisorCLK;
    reg clk;       

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= divisorCLK) begin 
            contador = 0;
            clk = ~clk;
        end 
    end 

    always @(posedge CLOCK_50) begin
        if (reset) begin
            divisorCLK = 200000;
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
                x = xi + 144 + 15;
                y = yi + 35;
                movimentar = 1;
                bateu = 0;
            end
            if (movimentar) begin
                if (ehAliada) begin
                    y = y - 1;
                end else begin
                    y = y + 1;
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