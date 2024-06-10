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
	// input [9:0] largura_nave,  
	// input [9:0] altura_nave,    
    
    input [9:0] x_inimigo,
    input [9:0] y_inimigo, 



    // input [9:0] largura_inimigo,
    // input [9:0] altura_inimigo,

	input [9:0] VGA_X,
	input [9:0] VGA_Y,
	output reg [7:0] VGA_R,    
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B
);
    reg [9:0] largura_inimigo = 11;
    reg [9:0] altura_inimigo = 8;
    reg [9:0] largura_nave = 15;
    reg [9:0] altura_nave = 17;

	// reg [7:0] buffer [0:640*480];

	// bola aliada
    wire [32:0] delta_x_aliado;
    wire [32:0] delta_y_aliado;
    wire [9:0] raioquadrado_aliado;
    assign delta_x_aliado = (x_bola_aliada - VGA_X) ** 2;
    assign delta_y_aliado = (y_bola_aliada - VGA_Y) ** 2;
    assign raioquadrado_aliado = raio_bola_aliada ** 2;

	// bola inimiga
    wire [32:0] delta_x_inimigo;
    wire [32:0] delta_y_inimigo;
    wire [9:0] raioquadrado_inimigo;
    assign delta_x_inimigo = (x_bola_inimiga - VGA_X) ** 2;
    assign delta_y_inimigo = (y_bola_inimiga - VGA_Y) ** 2;
    assign raioquadrado_inimigo = raio_bola_inimiga ** 2;

    reg [0:254] buffer_nave_R = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000000111000000000000111000000000101111101000000101101101000000011000110000100111010111001101111111111101111110111011111111000111000111110000010000011100000010000001;
    reg [0:254] buffer_nave_G = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000100111001000000100111001000000101111101000100101111101001100011111110001100111111111001101111111111101111111111111111111011111110111110011010110011100000010000001;
    reg [0:254] buffer_nave_B = 255'b000000010000000000000010000000000000010000000000000111000000000000111000000000000111000000000000111000000000101111101000000111101111000000111000111000100111010111001101111111111101111110111011111111000111000111110000010000011100000010000001;


    reg [0:88] buffer_inimigo_R = 255'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    reg [0:88] buffer_inimigo_G = 255'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;

    reg [3:0] multiplicador_nave;

    wire nave_r;
    wire nave_g;
    wire nave_b;

    buffer buffer_nave (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X - 144),
        .Y_VGA(VGA_Y - 35),
        .X_OBJETO(x_nave),
        .Y_OBJETO(y_nave),
        .LARGURA_OBJETO(largura_nave),
        .ALTURA_OBJETO(altura_nave),
        .MULTPLICADOR(multiplicador_nave),
        .BUFFER_R(buffer_nave_R << 146),
        .BUFFER_G(buffer_nave_G << 146),
        .BUFFER_B(buffer_nave_B << 146),
        .R_VGA(nave_r),
        .G_VGA(nave_g),
        .B_VGA(nave_b)
    );



        wire inimigo_r;
        wire inimigo_g;
        wire inimigo_b;
        reg [3:0] multiplicador_inimigo;
        
        buffer buffer_inimigo (
            .CLK(VGA_CLK),
            .reset(reset),
            .X_VGA(VGA_X - 144),
            .Y_VGA(VGA_Y - 35),
            .X_OBJETO(x_inimigo),
            .Y_OBJETO(y_inimigo),
            .LARGURA_OBJETO(largura_inimigo),
            .ALTURA_OBJETO(altura_inimigo),
            .MULTPLICADOR(multiplicador_inimigo),
            .BUFFER_R(buffer_inimigo_R << 312),
            .BUFFER_G(buffer_inimigo_G << 312),
            .BUFFER_B(buffer_inimigo_R << 312),
            .R_VGA(inimigo_r),
            .G_VGA(inimigo_g),
            .B_VGA(inimigo_b)
        );

    always @(posedge VGA_CLK or posedge reset) begin // implementar a lógica que será usada para "imprimir" na tela
        if (reset) begin
		   	VGA_R = 0;
            VGA_G = 0;
            VGA_B = 0;
            multiplicador_nave = 4'h3;
            multiplicador_inimigo = 4'h3;
        end else begin
            if (ativo && !perdeu) begin
                if (delta_x_aliado + delta_y_aliado < raioquadrado_aliado) begin // bola aliada
                    VGA_R = 255;
                    VGA_G = 255;
                    VGA_B = 255;
				// end else if (delta_x_inimigo + delta_y_inimigo < raioquadrado_inimigo) begin // bola inimiga
				end else if ((inimigo_r || inimigo_g || inimigo_b) && (x_inimigo + 144 <= VGA_X ) && (VGA_X <= 144 + x_inimigo + largura_inimigo * multiplicador_inimigo) && (y_inimigo + 35 <= VGA_Y) && (VGA_Y <= y_inimigo + 35 + altura_inimigo * multiplicador_inimigo)) begin // inimigo
					VGA_R = inimigo_r * 255;
					VGA_G = inimigo_g * 255;
					VGA_B = inimigo_b * 255;
				end else if ((nave_r || nave_g || nave_b) && (x_nave + 144 <= VGA_X ) && (VGA_X <= 144 + x_nave + largura_nave * multiplicador_nave) && (y_nave + 35 <= VGA_Y) && (VGA_Y <= y_nave + 35 + altura_nave * multiplicador_nave)) begin // nave
					VGA_R = nave_r * 255;
					VGA_G = nave_g * 255;
					VGA_B = nave_b * 255;
                end else begin
                    VGA_R = 0; 
                    VGA_G = 0;
                    VGA_B = 0;
                end
				
            end else begin 
                    VGA_R = 0;
                    VGA_G = 0;
                    VGA_B = 0;  
            end
        end
    end


endmodule