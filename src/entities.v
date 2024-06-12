module entities(
	input CLOCK_50,
    input reset,
    input pausa,
    input [3:0] keysout,
    output [9:0] x_bola_aliada,
    output [9:0] y_bola_aliada, 
    output [9:0] raio_bola_aliada, 
    output [9:0] x_bola_inimiga,
    output [9:0] y_bola_inimiga,
    output [9:0] raio_bola_inimiga,
    output [9:0] x_nave,
    output [9:0] y_nave,
    output [9:0] x_inimigo,
    output [9:0] y_inimigo,
    output inimigo_vivo,
    output [9:0] LEDR
);
    // assign x_bola_inimiga = 500;
    // assign y_bola_inimiga = 100;
    assign raio_bola_inimiga = 5;

    wire [9:0] xi_bola;
    wire [9:0] yi_bola;
    assign xi_bola = x_nave + (45 / 2);
    assign yi_bola = y_nave + 10  - 45/2;
    wire bateu;

    nave naveInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .keysout(keysout),
        .reiniciarJogo(0),
        .x_nave(x_nave),
        .y_nave(y_nave),
    );

    inimigo inimigoInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa), 
        .reiniciarJogo(0),
        .xi(20),
        .yi(40),
        .x(x_inimigo),
        .y(y_inimigo),
        .x_bola_nave(x_bola_aliada),
        .y_bola_nave(y_bola_aliada),
        .vivo(inimigo_vivo),
        .decrementar_vida_nave(),
        .x_bola(x_bola_inimiga),
        .y_bola(y_bola_inimiga),
        .x_nave(x_nave),
        .y_nave(y_nave),
        .LEDR(LEDR)
    );

    bola bolaAliada(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .reiniciarJogo(0),
        .xi(xi_bola),
        .yi(yi_bola),
        // .sentidoY(1),
        .x(x_bola_aliada),
        .y(y_bola_aliada),
        .raio(raio_bola_aliada)
    );

endmodule