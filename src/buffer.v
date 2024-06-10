module buffer(
    input CLK, 
    input reset,
    input [9:0] X_VGA,
    input [9:0] Y_VGA,
    input [9:0] X_OBJETO,
    input [9:0] Y_OBJETO,
    input [9:0] LARGURA_OBJETO, // pior dos dados LARGURA_OBJETO = 40
    input [9:0] ALTURA_OBJETO, // pior dos dados ALTURA_OBJETO = 40 
    input [9:0] MULTPLICADOR,
    input [0:400] BUFFER_R, // pior caso 1600 = 12'b 0110 0100 0000
    input [0:400] BUFFER_G, // caso a imagem seja menor, não ha problema, ela será oculpado do 0 para o 11 digito
    input [0:400] BUFFER_B,
    output R_VGA, // sempre irei retornar o 3 bit mais significativos do RGB
    output G_VGA, 
    output B_VGA    
);
    reg [9:0] X_BUFFER;  
    reg [9:0] Y_BUFFER;
    
    wire [9:0] indice;
    assign indice = (Y_BUFFER / MULTPLICADOR) * LARGURA_OBJETO + X_BUFFER / MULTPLICADOR;

    wire enable_read;
    assign enable_read = (X_OBJETO <= X_VGA) && (X_VGA <= X_OBJETO + LARGURA_OBJETO * MULTPLICADOR) &&  (Y_OBJETO <= Y_VGA) && (Y_VGA <= Y_OBJETO + ALTURA_OBJETO * MULTPLICADOR);

    // indice = (VGA_Y - 35) / 10 * (64) + ((VGA_X - 144) / 10); 


    assign R_VGA = enable_read ? BUFFER_R [indice] : 0;
    assign G_VGA = enable_read ? BUFFER_G [indice] : 0;
    assign B_VGA = enable_read ? BUFFER_B [indice] : 0; 

    always @(posedge CLK) begin 
        if (reset) begin
            X_BUFFER = 0;
            Y_BUFFER = 0;
        end else begin
            if (enable_read) begin
                if (X_BUFFER == LARGURA_OBJETO * MULTPLICADOR ) begin
                    X_BUFFER = 0;
                    if (Y_BUFFER == ALTURA_OBJETO * MULTPLICADOR) begin
                        Y_BUFFER = 0;
                    end else begin
                        Y_BUFFER = Y_BUFFER + 1;
                    end
                end else begin
                    X_BUFFER = X_BUFFER + 1;
                end
            end
        end
    end


endmodule