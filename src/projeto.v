module projeto(
	input CLOCK_50,
	input [9:0] SW,
	input [3:0] KEY,
	output wire [7:0] VGA_R, 
    output wire [7:0] VGA_G,     
    output wire [7:0] VGA_B,   
	output wire VGA_HS,   
	output wire VGA_VS,  
	output wire VGA_BLANK_N,  
	output wire VGA_SYNC_N, 
	output wire VGA_CLK,   
	output [6:0] HEX0, // digito da direita
  	output [6:0] HEX1,
  	output [6:0] HEX2,
  	output [6:0] HEX3,
  	output [6:0] HEX4, 
  	output [6:0] HEX5, // digito da esquerda 
	output [9:0] LEDR
);
    wire [3:0] keysout;
    wire reset;
    wire pausa;
    assign reset = SW[0];
    assign pausa = SW[1];

    wire [9:0] VGA_X;
    wire [9:0] VGA_Y; 
    wire ativoVGA;

    wire [9:0] x_bola_aliada;
    wire [9:0] y_bola_aliada;
    wire [9:0] raio_bola_aliada;

    wire [9:0] x_bola_inimiga;
    wire [9:0] y_bola_inimiga;
    wire [9:0] raio_bola_inimiga;
    wire inimigo_vivo;

    wire [9:0] x_nave;
    wire [9:0] y_nave;
    wire [9:0] largura_nave;
    wire [9:0] altura_nave;

    wire [9:0] x_inimigo;
    wire [9:0] y_inimigo;
    wire [9:0] largura_inimigo;
    wire [9:0] altura_inimigo;

    entities entitiesInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .keysout(keysout),
        .pausa(pausa),
        .x_bola_aliada(x_bola_aliada),
        .y_bola_aliada(y_bola_aliada),
        .raio_bola_aliada(raio_bola_aliada),
        .x_bola_inimiga(x_bola_inimiga),
        .y_bola_inimiga(y_bola_inimiga),
        .raio_bola_inimiga(raio_bola_inimiga),
        .x_nave(x_nave),
        .y_nave(y_nave),
        .largura_nave(largura_nave),
        .altura_nave(altura_nave),
        .x_inimigo(x_inimigo),
        .y_inimigo(y_inimigo),
        .largura_inimigo(largura_inimigo), 
        .altura_inimigo(altura_inimigo),
        .inimigo_vivo(inimigo_vivo)
    );

    vga v(
		.CLOCK_50(CLOCK_50),
		.reset(reset),
		.VGA_CLK(VGA_CLK),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
		.x(VGA_X),
		.y(VGA_Y),
		.ativo(ativoVGA)
	);

    keys keysInstancia(
		.CLOCK_50(CLOCK_50),
		.keys(KEY),
		.keysout(keysout)
	);

    tela telaInstancia(
		.VGA_CLK(VGA_CLK),
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .ativo(ativoVGA),
        .perdeu(0),

        .x_bola_aliada(x_bola_aliada),
        .y_bola_aliada(y_bola_aliada),
        .raio_bola_aliada(raio_bola_aliada),

        .x_bola_inimiga(x_bola_inimiga),
        .y_bola_inimiga(y_bola_inimiga),
        .raio_bola_inimiga(raio_bola_inimiga),

        .x_nave(x_nave),
        .y_nave(y_nave),
        .largura_nave(largura_nave),
        .altura_nave(altura_nave),

        .x_inimigo(x_inimigo),
        .y_inimigo(y_inimigo),
        .inimigo_vivo(inimigo_vivo),
        // .largura_inimigo(largura_inimigo),
        // .altura_inimigo(altura_inimigo),

        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .LEDR(LEDR)
    );


endmodule