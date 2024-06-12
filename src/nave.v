module nave(
    input CLOCK_50,
    input reset,
    input [3:0] keysout,
    input pausa,
	input reiniciarJogo,

    output reg iniciarBola,
    input bateu,

    input [9:0] largura_nave,
    input [9:0] altura_nave,
    output reg [9:0] x_nave,
    output reg [9:0] y_nave
);
    assign resetNave = reset || reiniciarJogo;

    always @(posedge CLOCK_50 or posedge resetNave) begin
        if (resetNave) begin   
            x_nave = 350;
            y_nave = 410;
            iniciarBola = 0;
        end else if (pausa == 0) begin
            if (pausa == 0) begin
                if (keysout[0] && x_nave + largura_nave <= 640) begin // direita
                    x_nave = x_nave + 2;
                end
                if (keysout[1] && x_nave > 0) begin // esquerda
                    x_nave = x_nave - 2;
                end
                if (bateu) begin // eu sei que não faz sentido, mas toda vez que tiro para de funcionar
                    iniciarBola = 0; // não mexer!!!!
                end
            end
        end
    end

endmodule