module bola(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] xi, 
    input [9:0] yi,
    // input sentidoY,
    output reg [9:0] x,
    output reg [9:0] y,
    output [9:0] raio
);
    reg clk;
    reg movimentar;
    reg [32:0] contador;
    assign raio = 5;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 50000) begin 
            contador = 0;
            clk = ~clk;
        end 
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x = xi;
            y = yi;
        end else if (pausa == 0) begin
            // if (sentidoY) begin
                y = y - 1;
            // end else begin
            //     y = y + 1;
            // end
            if (y >= 480) begin
                x = xi;
                y = yi - 35;
            end
        end
    end

endmodule