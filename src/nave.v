module nave(
    input CLOCK_50,
    input reset,
    input [3:0] keysout,
    input pausa,
	input reiniciarJogo,

    output reg iniciarBola,
    input bateu,
    output reg [9:0] x_nave,
    output reg [9:0] y_nave
);
    assign resetNave = reset || reiniciarJogo;

    reg [9:0] largura_nave;

    always @(posedge CLOCK_50 or posedge resetNave) begin
        if (resetNave) begin   
            x_nave = 320;
            y_nave = 410;
            iniciarBola = 0;
            largura_nave = 45;
        end else if (pausa == 0) begin
            if (pausa == 0) begin
                if (keysout[0] && x_nave + largura_nave <= 640) begin // direita
                    x_nave = x_nave + 2;
                end
                if (keysout[1] && x_nave > 0) begin // esquerda
                    x_nave = x_nave - 2;
                end
                if (bateu) begin
                    iniciarBola = 0;
                end
            end
        end
    end

endmodule