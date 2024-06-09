module nave(
    input CLOCK_50,
    input reset,
    input [3:0] keysout,
    input pausa,
	input reiniciarJogo,

    output reg iniciarBola,
    input bateu,

    output wire [9:0] largura_nave,
    output wire [9:0] altura_nave,
    output reg [9:0] x_nave,
    output reg [9:0] y_nave
);

    assign largura_nave = 30;
    assign altura_nave = 30;
    assign resetNave = reset || reiniciarJogo;

    always @(posedge CLOCK_50 or posedge resetNave) begin
        if (resetNave) begin
            x_nave = 350;
            y_nave = 420;
            iniciarBola = 0;
        end else if (pausa == 0) begin
            if (pausa == 0) begin
                if (keysout[0]) begin // direita
                    x_nave = x_nave + 1;
                end
                if (keysout[1]) begin // esquerda
                    x_nave = x_nave - 1;
                end
                if (bateu) begin
                    iniciarBola = 0;
                end
            end
        end
    end

endmodule