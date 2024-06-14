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
    // input [15:0] op
);
    reg clk;
    reg movimentar;
    reg [32:0] contador;
    reg [32:0] teste;
    reg clka;
 
    reg comecar;

    reg [3:0] opLocal = 4'hf;

    // assign bateunave = (x >= x_nave) && (x <= x_nave + 45) && (y >= y_nave) && (y <= y_nave + 51);

    always@(posedge clka) begin
        if (pausa == 0) begin
            opLocal = {opLocal[2:0],(opLocal[3]^opLocal[2])};
        end
    end

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 50000) begin 
            contador = 0;
            clk = ~clk;
        end 
    end

    always @(posedge CLOCK_50) begin //divisor de clock
        teste = teste + 1;
        if (teste >= 50000000) begin 
            teste = 0;
            clka = ~clka;
        end 
    end

    // always @(posedge CLOCK_50 or posedge reset) begin
    //     if (reset) begin
    //         bateunave = 0;
    //     end else begin
    //         if (x_nave <= x && x <= x_nave + 45 && y_nave <= y && y <= y_nave + 51) begin 
    //             bateunave = 1;
    //         end else begin
    //             bateunave = 0;
    //         end
    //     end
    // end

    always @(negedge clk or posedge reset) begin
        if (reset) begin
            comecar = 0;
            x = 1000;
            y = 1000;
            n_batidas = 0;
        end else if (pausa == 0) begin
            if (!bola_morta) begin

                if ((opLocal%8 == 1 || opLocal%8==3)  && !comecar) begin
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