module tela(
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
     
    input [9:0] x_inimigo,
    input [9:0] y_inimigo, 
    input inimigo_vivo,

	input [9:0] VGA_X,
	input [9:0] VGA_Y,
	output reg [7:0] VGA_R,    
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B

);

	// bola aliada
    wire [32:0] delta_x_aliado;
    wire [32:0] delta_y_aliado;
    wire [9:0] raioquadrado_aliado;
    assign delta_x_aliado = (x_bola_aliada + 144 - VGA_X) ** 2;
    assign delta_y_aliado = (y_bola_aliada + 35 - VGA_Y) ** 2;
    assign raioquadrado_aliado = raio_bola_aliada ** 2;

	// bola inimiga
    wire [32:0] delta_x_inimigo;
    wire [32:0] delta_y_inimigo;
    wire [9:0] raioquadrado_inimigo;
    assign delta_x_inimigo = (x_bola_inimiga - VGA_X) ** 2;
    assign delta_y_inimigo = (y_bola_inimiga - VGA_Y) ** 2;
    assign raioquadrado_inimigo = raio_bola_inimiga ** 2;
    
    //inimigo
    wire inimigo_r;
    wire inimigo_g;
    wire inimigo_b;
    reg [3:0] multiplicador_inimigo;
    reg [9:0] largura_inimigo_imagem;
    reg [9:0] altura_inimigo_imagem;
    reg [0:88] buffer_inimigo_R = 255'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    reg [0:88] buffer_inimigo_G = 255'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;
    buffer buffer_inimigo (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X - 144),
        .Y_VGA(VGA_Y - 35),
        .X_OBJETO(x_inimigo),
        .Y_OBJETO(y_inimigo),
        .LARGURA_OBJETO(largura_inimigo_imagem),
        .ALTURA_OBJETO(altura_inimigo_imagem),
        .MULTPLICADOR(multiplicador_inimigo),
        .BUFFER_R(buffer_inimigo_R << 312),
        .BUFFER_G(buffer_inimigo_G << 312),
        .BUFFER_B(buffer_inimigo_R),
        .R_VGA(inimigo_r),
        .G_VGA(inimigo_g),
        .B_VGA(inimigo_b)
    );


    // nave
    wire nave_r;
    wire nave_g;
    wire nave_b;
    reg [3:0] multiplicador_nave;
    reg [9:0] largura_nave_imagem;
    reg [9:0] altura_nave_imagem;
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
        .BUFFER_B(buffer_nave_B << 146),
        .R_VGA(nave_r),
        .G_VGA(nave_g),
        .B_VGA(nave_b)
    );

    // coracao
    wire coracao_r;
    wire coracao_g;
    wire coracao_b;
    reg [3:0] multiplicador_coracao;
    reg [9:0] largura_coracao_imagem;
    assign largura_coracao = largura_coracao_imagem * multiplicador_coracao;
    reg [0:99] buffer_coracao_R = 100'b0011001100011111111011111111111111111111111111111101111111100011111100000111100000001100000000000000;
    reg [0:99] buffer_coracao_G = 100'b0011001100010011001010000001011000000001100000000101000000100010000100000100100000001100000000000000;
    reg [0:99] buffer_coracao_B = 100'b0011001100010011001010000001011000000001100000000101000000100010000100000100100000001100000000000000;

    buffer buffer_coracao (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X - 144),
        .Y_VGA(VGA_Y - 35),
        .X_OBJETO(10),
        .Y_OBJETO(10),
        .LARGURA_OBJETO(largura_coracao_imagem),
        .ALTURA_OBJETO(largura_coracao_imagem),
        .MULTPLICADOR(multiplicador_coracao),
        .BUFFER_R(buffer_coracao_R << 300),
        .BUFFER_G(buffer_coracao_G << 300),
        .BUFFER_B(buffer_coracao_B),
        .R_VGA(coracao_r),
        .G_VGA(coracao_g),
        .B_VGA(coracao_b)
    );

    //fundo
    wire fundo_r;
    wire fundo_g;
    wire fundo_b;
    reg [9:0] largura_fundo_imagem;
    reg [3:0] multiplicador_fundo;
    reg [0:399] buffer_fundo_r = 400'b0000000000000000000000110000000000100000001100000000011100000000000000000010000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000110000000000000000001100011000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000100000000000000000011100000000000000000010000000000000000000000100000000000;
    reg [0:399] buffer_fundo_g = 400'b0000000000000000000000110000000000100000001100000000011100000000000000000010000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000110000000000000000001100011000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000100000000000000000011100000000000000000010000000000000000000000100000000000;
    reg [0:399] buffer_fundo_b = 400'b0000000000000000000000110000000000100000001100000000011100000000000000000010000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000110000000000000000001100011000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000100000000000000000011100000000000000000010000000000000000000000100000000000;

    buffer buffer_fundo (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X - 144),
        .Y_VGA(VGA_Y - 35),
        .X_OBJETO(200),
        .Y_OBJETO(200),
        .LARGURA_OBJETO(largura_fundo_imagem),
        .ALTURA_OBJETO(largura_fundo_imagem),
        .MULTPLICADOR(multiplicador_fundo),
        .BUFFER_R(buffer_fundo_R),
        .BUFFER_G(buffer_fundo_G),
        .BUFFER_B(buffer_fundo_B),
        .R_VGA(fundo_r),
        .G_VGA(fundo_g),
        .B_VGA(fundo_b)
    );




    always @(posedge VGA_CLK or posedge reset) begin // implementar a lógica que será usada para "imprimir" na tela
        if (reset) begin
		   	VGA_R = 0;
            VGA_G = 0;
            VGA_B = 0;
            multiplicador_inimigo = 4'd3;
            largura_inimigo_imagem = 9'd11;
            altura_inimigo_imagem = 9'd8;

            multiplicador_nave = 4'd3;
            largura_nave_imagem = 9'd15;
            altura_nave_imagem = 9'd17;

            multiplicador_coracao = 4'd3;
            largura_coracao_imagem = 9'd10; 

        largura_fundo_imagem = 9'd20;
            multiplicador_fundo = 4'd3;
        end else begin
            if (ativo && !perdeu) begin
                if (delta_x_aliado + delta_y_aliado < raioquadrado_aliado) begin // bola aliada
                    VGA_R = 255;
                    VGA_G = 255;
                    VGA_B = 255;
				end else if (inimigo_vivo && (inimigo_r || inimigo_g || inimigo_b)) begin // inimigo
					VGA_R = inimigo_r * 255;
					VGA_G = inimigo_g * 255;
					VGA_B = inimigo_b * 255;
				end else if (nave_r || nave_g || nave_b) begin // nave
					VGA_R = nave_r * 255;
					VGA_G = nave_g * 255;
					VGA_B = nave_b * 255;
                end else if (coracao_r || coracao_g || coracao_b) begin // nave
					VGA_R = coracao_r * 255;
					VGA_G = coracao_g * 255;
					VGA_B = coracao_b * 255;
                end else if (fundo_r || fundo_g || fundo_b) begin
                    VGA_R = fundo_r * 255; 
                    VGA_G = fundo_g * 255;
                    VGA_B = fundo_b * 255;
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