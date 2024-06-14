module nave(
    input CLOCK_50,
    input reset,
    input pausa,
    input [3:0] keysout,
	input reiniciarJogo,
    output reg [9:0] x_nave,
    output reg [9:0] y_nave,
    output [1:0] vidas,
    input [1:0] n_batidas,
    output reg perdeu,
    output [9:0] LEDR
);
    assign resetNave = reset || reiniciarJogo;

    reg [9:0] largura;
    reg [9:0] altura;

    assign vidas = 2'b11 - n_batidas;
    assign LEDR = vidas;

    // always @(posedge atingiu) begin
    //         if (resetNave) begin   
    //             vidas = 3;
    //             perdeu = 0;
    //         end else begin
    //             if (vidas == 0) begin
    //                 perdeu = 1;
    //             end else begin
    //                 vidas = vidas - 1;
    //             end
    //         end
    // end

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin   
            x_nave = 320;
            y_nave = 410;
            largura = 45;
            altura = 51;
            // vidas = 3;
            perdeu = 0;
        end else begin
            if (pausa == 0) begin
                if (keysout[0] && x_nave + largura <= 640) begin // direita
                    x_nave = x_nave + 2;
                end
                if (keysout[1] && x_nave > 0) begin // esquerda
                    x_nave = x_nave - 2;
                end
                if (vidas == 0) begin
                    perdeu = 1;
                end
            end
        end
    end

endmodule