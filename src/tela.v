module tela(
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
	input [9:0] largura_nave,
	input [9:0] altura_nave,

    input [9:0] x_inimigo,
    input [9:0] y_inimigo,
    input [9:0] largura_inimigo,
    input [9:0] altura_inimigo,

	input [9:0] VGA_X,
	input [9:0] VGA_Y,
	output reg [7:0] VGA_R,    
	output reg [7:0] VGA_G, 
	output reg [7:0] VGA_B
);

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

    always @(posedge CLOCK_50 or posedge reset) begin // implementar a lógica que será usada para "imprimir" na tela
        if (reset) begin
		   	VGA_R = 0;
            VGA_G = 0;
            VGA_B = 0;
        end else begin
            if (ativo && !perdeu) begin
                if (delta_x_aliado + delta_y_aliado < raioquadrado_aliado) begin // bola aliada
                    VGA_R = 255;
                    VGA_G = 255;
                    VGA_B = 255;
				end else if (delta_x_inimigo + delta_y_inimigo < raioquadrado_inimigo) begin // bola inimiga
					VGA_R = 255;
					VGA_G = 0;
					VGA_B = 0;
				end else if ((x_nave + 144 <= VGA_X ) && (VGA_X <= 144 + x_nave + largura_nave) && (y_nave + 35 <= VGA_Y) && (VGA_Y <= y_nave + 35 + altura_nave)) begin // nave
				    VGA_R = 255;
					VGA_G = 255;
					VGA_B = 255;
                end else if ((x_inimigo + 144 <= VGA_X ) && (VGA_X <= 144 + x_inimigo + largura_inimigo) && (y_inimigo + 35 <= VGA_Y) && (VGA_Y <= y_inimigo + 35 + altura_inimigo)) begin
                    VGA_R = 0;
                    VGA_G = 255;
                    VGA_B = 0;
                end else begin
                    VGA_R = 0; 
                    VGA_G = 50;
                    VGA_B = 50;
                end
				
            end else begin 
                    VGA_R = 0;
                    VGA_G = 0;
                    VGA_B = 0;  
            end
        end
    end


endmodule