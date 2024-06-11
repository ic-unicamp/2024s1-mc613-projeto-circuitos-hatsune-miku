module entities(
	input CLOCK_50,
    input reset,
    input [3:0] keysout,
    input pausa,

    output [9:0] x_bola_aliada,
    output [9:0] y_bola_aliada,
    output [9:0] raio_bola_aliada,

    output [9:0] x_bola_inimiga,
    output [9:0] y_bola_inimiga,
    output [9:0] raio_bola_inimiga,

    output [9:0] x_nave,
    output [9:0] y_nave,
    input [9:0] largura_nave,
    input [9:0] altura_nave,

    output [9:0] x_inimigo,
    output [9:0] y_inimigo,
    output [9:0] largura_inimigo,
    output [9:0] altura_inimigo,
    output inimigo_vivo
);
    assign x_bola_inimiga = 500;
    assign y_bola_inimiga = 100;
    assign raio_bola_inimiga = 5;

    // assign Reset = reset || reiniciarJogo;

    wire [9:0] xi_bola;
    wire [9:0] yi_bola;
    assign xi_bola = x_nave + (largura_nave / 2);
    assign yi_bola = y_nave;
    wire bateu;
    wire iniciarBola;

    nave naveInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .keysout(keysout),
        .pausa(pausa),
        .reiniciarJogo(0),

        .iniciarBola(iniciarBola),
        .bateu(bateu),

        .largura_nave(largura_nave),
        .altura_nave(altura_nave),
        .x_nave(x_nave),
        .y_nave(y_nave),
    );

    inimigo inimigoInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .reiniciarJogo(0),

        .largura(largura_inimigo),
        .altura(altura_inimigo),
        .x(x_inimigo),
        .y(y_inimigo),

        .bola_nave_x(x_bola_aliada),
        .bola_nave_y(x_bola_aliada),
        .vivo(inimigo_vivo)
    );

    bola bolaAliada(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .reiniciarJogo(0),
        .xi(xi_bola),
        .yi(yi_bola),
        .ehAliada(1),
        .iniciar_movimento(1),
        .bateu(bateu),
        .x(x_bola_aliada),
        .y(y_bola_aliada),
        .raio(raio_bola_aliada),
        .larguraAtirador(largura_nave)
    );

endmodule