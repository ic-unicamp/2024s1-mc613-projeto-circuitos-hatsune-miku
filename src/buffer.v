module buffer(
    input CLK,
    input reset,
    input [9:0] X_VGA,
    input [9:0] Y_VGA,
    input [9:0] X_OBJETO,
    input [9:0] Y_OBJETO,
    input [7:0] LARGURA_OBJETO, // pior dos dados LARGURA_OBJETO = 40
    input [7:0] ALTURA_OBJETO, // pior dos dados ALTURA_OBJETO = 40
    input [0:237] BUFFER_R, // pior caso 1600 = 12'b 0110 0100 0000
    input [0:237] BUFFER_G, // caso a imagem seja menor, não ha problema, ela será oculpado do 0 para o 11 digito
    input [0:237] BUFFER_B,
    output reg R_VGA, // sempre irei retornar o 3 bit mais significativos do RGB
    output reg G_VGA,
    output reg B_VGA
);
    reg [9:0] X_ATUAL;
    reg [9:0] Y_ATUAL;

    always @(posedge CLK) begin
        if (reset) begin
            X_ATUAL = 0;
            Y_ATUAL = 0;
        end else begin
            if ((X_OBJETO + X_ATUAL == X_VGA) && (Y_OBJETO + Y_ATUAL == Y_VGA)) begin
                R_VGA = BUFFER_R [Y_ATUAL * LARGURA_OBJETO + X_ATUAL];
                G_VGA = BUFFER_G [Y_ATUAL * LARGURA_OBJETO + X_ATUAL];
                B_VGA = BUFFER_B [Y_ATUAL * LARGURA_OBJETO + X_ATUAL];

                Y_ATUAL = Y_ATUAL + (X_ATUAL / (LARGURA_OBJETO - 2));
                X_ATUAL = (X_ATUAL + 1'b1) % (LARGURA_OBJETO - 1);
            end else begin
                R_VGA = 0;
                G_VGA = 0;
                B_VGA = 0;
            end
        end
    end


endmodule