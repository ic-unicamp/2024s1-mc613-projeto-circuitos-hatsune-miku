module tela #(parameter SIZE_ENEMY=10)(
    input VGA_CLK,
    input CLOCK_50,
	input reset, 
	input ativo,
	input perdeu,

	input [9:0] x_bola_aliada, 
	input [9:0] y_bola_aliada,
	input [9:0] raio_bola_aliada,
	input [9:0] x_bola_inimiga,
	input [9:0] y_bola_inimiga,  
	input [9:0] raio_bola_inimiga,  

	input [9:0] x_nave, 
	input [9:0] y_nave,   
	output wire [9:0] largura_nave,  
	output wire [9:0] altura_nave,    
    
    // input [9:0] x_inimigo,
    // input [9:0] y_inimigo, 
    // input inimigo_vivo,

    input [10*(SIZE_ENEMY) - 1 :0] x_inimigo,
    input [10*(SIZE_ENEMY) - 1 :0] y_inimigo,
    input [(SIZE_ENEMY-1):0] vidas_inimigo,

    output wire [9:0] largura_inimigo,
    output wire [9:0] altura_inimigo,

	input [9:0] VGA_X,
	input [9:0] VGA_Y,
	output reg [7:0] VGA_R,    
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B,
	output [9:0] LEDR

);
    assign largura_inimigo = 11;
    assign altura_inimigo = 8;

	// bola aliada
    wire [32:0] delta_x_aliado;
    wire [32:0] delta_y_aliado;
    wire [9:0] raioquadrado_aliado;
    assign delta_x_aliado = (x_bola_aliada + 144 - VGA_X) ** 2;
    assign delta_y_aliado = (y_bola_aliada + 144 - VGA_Y) ** 2;
    assign raioquadrado_aliado = raio_bola_aliada ** 2;

	// bola inimiga
    wire [32:0] delta_x_inimigo;
    wire [32:0] delta_y_inimigo;
    wire [9:0] raioquadrado_inimigo;
    assign delta_x_inimigo = (x_bola_inimiga - VGA_X) ** 2;
    assign delta_y_inimigo = (y_bola_inimiga - VGA_Y) ** 2;
    assign raioquadrado_inimigo = raio_bola_inimiga ** 2;



    reg [0:88] buffer_inimigo_R = 255'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    reg [0:88] buffer_inimigo_G = 255'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;

    reg [3:0] multiplicador_nave;

    // nave
    wire nave_r;
    wire nave_g;
    wire nave_b;
    reg [9:0] largura_nave_imagem;
    reg [9:0] altura_nave_imagem;
    assign largura_nave = largura_nave_imagem * multiplicador_nave;
    assign altura_nave = altura_nave_imagem * multiplicador_nave;
    reg [0:254] buffer_nave_R = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000000111000000000000111000000000101111101000000101101101000000011000110000100111010111001101111111111101111110111011111111000111000111110000010000011100000010000001;
    reg [0:254] buffer_nave_G = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000100111001000000100111001000000101111101000100101111101001100011111110001100111111111001101111111111101111111111111111111011111110111110011010110011100000010000001;
    reg [0:254] buffer_nave_B = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000000111000000000000111000000000101111101000000111101111000000111000111000100111010111001101111111111101111110111011111111000111000111110000010000011100000010000001;

    buffer buffer_nave (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X - 144),
        .Y_VGA(VGA_Y - 35),
        .X_OBJETO(x_nave),
        .Y_OBJETO(y_nave),
        .LARGURA_OBJETO(largura_nave_imagem),
        .ALTURA_OBJETO(altura_nave_imagem),
        .MULTPLICADOR(multiplicador_nave),
        .BUFFER_R(buffer_nave_R << 146),
        .BUFFER_G(buffer_nave_G),
        .BUFFER_B(buffer_nave_B),
        .R_VGA(nave_r),
        .G_VGA(nave_g),
        .B_VGA(nave_b)
    );

    wire [SIZE_ENEMY:0] inimigo_r;
    wire [SIZE_ENEMY:0] inimigo_g;
    wire [SIZE_ENEMY:0] inimigo_b;
    reg [3:0] multiplicador_inimigo;

    genvar j;

    generate
        for (j =  1; j <= SIZE_ENEMY ; j = j + 1) begin: buffer_loop
            // if (vidas_inimigo[j] == 0) begin
                buffer buffer_inimigo (
                    .CLK(VGA_CLK),
                    .reset(reset),
                    .X_VGA(VGA_X - 144),
                    .Y_VGA(VGA_Y - 35),
                    .X_OBJETO(x_inimigo[(j * 10) - 1 : (j - 1) * 10]),
                    .Y_OBJETO(y_inimigo[(j * 10) - 1 : (j - 1) * 10]),
                    .LARGURA_OBJETO(largura_inimigo),
                    .ALTURA_OBJETO(altura_inimigo),
                    .MULTPLICADOR(multiplicador_inimigo),
                    .BUFFER_R(buffer_inimigo_R << 312),
                    .BUFFER_G(buffer_inimigo_G << 312),
                    .BUFFER_B(buffer_inimigo_R),
                    .R_VGA(inimigo_r[j-1]),
                    .G_VGA(inimigo_g[j-1]),
                    .B_VGA(inimigo_b[j-1])
                );
            // end
        end
    endgenerate
        


    always @(posedge VGA_CLK or posedge reset) begin // implementar a lógica que será usada para "imprimir" na tela
        if (reset) begin
		   	VGA_R = 0;
            VGA_G = 0;
            VGA_B = 0;
            multiplicador_inimigo = 4'h3;

            multiplicador_nave = 4'h3;
            largura_nave_imagem = 9'd15;
            altura_nave_imagem = 9'd17;
        end else begin
            integer k = 1;
            if (ativo && !perdeu) begin
                for (k = 1;k <= SIZE_ENEMY ; k = k + 1) begin
                    if ((x_inimigo[(k * 10) - 1 : (k - 1) * 10] + 144 <= VGA_X ) && (VGA_X <= 144 + x_inimigo[(k * 10) - 1 : (k - 1) * 10] + (largura_inimigo * multiplicador_inimigo)) && (y_inimigo[(k * 10) - 1 : (k - 1) * 10] + 35 <= VGA_Y) && (VGA_Y <= y_inimigo[(k * 10) - 1 : (k - 1) * 10] + 35 + altura_inimigo * multiplicador_inimigo)) begin // inimigo
                        VGA_R = 255;
                        VGA_G = 255;
                        VGA_B = 255;
                    end      
                end

                if (delta_x_aliado + delta_y_aliado < raioquadrado_aliado) begin // bola aliada
                    VGA_R = 255;
                    VGA_G = 255;
                    VGA_B = 255;
                end else if ((nave_r || nave_g || nave_b) && (x_nave + 144 <= VGA_X ) && (VGA_X <= 144 + x_nave + largura_nave) && (y_nave + 35 <= VGA_Y) && (VGA_Y <= y_nave + 35 + altura_nave)) begin // nave
                    VGA_R = nave_r * 255;
                    VGA_G = nave_g * 255;
                    VGA_B = nave_b * 255;
                end else begin
                    VGA_R = 30; 
                    VGA_G = 30;
                    VGA_B = 30;
                end

            end else begin 
                VGA_R = 0;
                VGA_G = 0;
                VGA_B = 0;  
            end
        end
    end


endmodule