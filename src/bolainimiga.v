module bolainimiga(
    input CLOCK_50,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] xi, 
    input [9:0] yi,
    input [9:0] x_nave,
    input [9:0] y_nave,
    output reg [9:0] x, 
    output reg [9:0] y,
    output reg [1:0] n_batidas,
    input bola_morta
);
    reg clk;
    reg movimentar;
    reg [32:0] contador;
    reg [32:0] contador_clk_lfsr;
    wire [9:0] random;
    reg clk_lfsr;
 

    reg comecar;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 50000) begin 
            contador = 0;
            clk = ~clk;
        end 
    end

    always @(posedge CLOCK_50) begin //divisor de clock
        contador_clk_lfsr = contador_clk_lfsr + 1;
        if (contador_clk_lfsr >= 50000000) begin 
            contador_clk_lfsr = 0;
            clk_lfsr = ~clk_lfsr;
        end 
    end

    lfsr lfsrInstance(
        .clk(clk_lfsr),
        .reset(reset),
        .seed(xi),
        .lfsrRegister(random)
    );

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            comecar = 0;
            x = 1000;
            y = 1000;
            n_batidas = 0;
        end else if (pausa == 0) begin
            if (!bola_morta) begin

                if ((random%20 == 5)  && !comecar) begin
                    x = xi;
                    y = yi;
                    comecar = 1;
                end

                if (comecar) begin
                    if (y >= 480) begin // chegou na borda
                        x = 1000;
                        y = 1000;
                        comecar = 0;
                    end else if (x >= x_nave && x <= x_nave + 45 && y >= y_nave && y <= y_nave + 51) begin 
                        comecar = 0;
                        x = 1000;
                        y = 1000;
                        n_batidas = n_batidas + 1;
                    end else begin // descer
                        y = y + 1;
                    end 
                    
                end

            end else begin
                x = 1000;
                y = 1000;
            end
        end
    end
            

endmodule