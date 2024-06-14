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

    wire [49:0] x_bola_inimiga;
    wire [49:0] y_bola_inimiga;
    wire [9:0] raio_bola_inimiga;
    wire [0:4] inimigo_vivo_array;

    wire [9:0] x_nave;
    wire [9:0] y_nave;
    wire [9:0] largura_nave;
    wire [9:0] altura_nave;

    wire [49:0] inimigo_x;
    wire [49:0] inimigo_y;

    wire [9:0] largura_inimigo;
    wire [9:0] altura_inimigo;

    wire perdeu;
    wire [1:0] vidas;

    reg [3:0] pontos;
    
    always @(*) begin
        if (reset) begin
            pontos = 0;
        end else begin
            pontos = 5 - (inimigo_vivo_array[0] + inimigo_vivo_array[1] + inimigo_vivo_array[2] + inimigo_vivo_array[3] + inimigo_vivo_array[4]);
        end
    end

    cb7s cb7_Instancia_1(
        .clk(CLOCK_50),
        .entrada(pontos),
        .saida(HEX0)
    ); 

    entities entitiesInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .keysout(keysout),
        .x_bola_aliada(x_bola_aliada),
        .y_bola_aliada(y_bola_aliada),
        .raio_bola_aliada(raio_bola_aliada),
        .x_bola_inimiga(x_bola_inimiga),
        .y_bola_inimiga(y_bola_inimiga),
        .raio_bola_inimiga(raio_bola_inimiga),
        .x_nave(x_nave),
        .y_nave(y_nave),
        .inimigo_x(inimigo_x),
        .inimigo_y(inimigo_y),
        .inimigo_vivo_array(inimigo_vivo_array),
        .vidas(vidas),
        .perdeu(perdeu),
        .LEDR(LEDR)

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
        .perdeu(perdeu),
        .vidas(vidas),

        .x_bola_aliada(x_bola_aliada),
        .y_bola_aliada(y_bola_aliada),
        .raio_bola_aliada(raio_bola_aliada),

        .x_bola_inimiga(x_bola_inimiga),
        .y_bola_inimiga(y_bola_inimiga),
        .raio_bola_inimiga(raio_bola_inimiga),

        .x_nave(x_nave),
        .y_nave(y_nave),

        .inimigo_x(inimigo_x),
        .inimigo_y(inimigo_y),
        .inimigo_vivo_array(inimigo_vivo_array),


        .VGA_X(VGA_X),
        .VGA_Y(VGA_Y),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B)
    );


endmodule