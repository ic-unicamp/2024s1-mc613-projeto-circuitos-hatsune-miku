module entities(
	input CLOCK_50,
    input reset,
    input pausa,
    input [3:0] keysout,
    output [9:0] x_bola_aliada,
    output [9:0] y_bola_aliada, 
    output [49:0] raio_bola_aliada, 
    output [49:0] x_bola_inimiga,
    output [9:0] y_bola_inimiga,
    output [9:0] raio_bola_inimiga,
    output [9:0] x_nave,
    output [9:0] y_nave,

    output [49:0] inimigo_x,
    output [49:0] inimigo_y,
    output [0:4] inimigo_vivo_array 
);
    // assign x_bola_inimiga = 500;
    // assign y_bola_inimiga = 100;
    assign raio_bola_inimiga = 5;

    // assign Reset = reset || reiniciarJogo;
    wire [9:0] xi_bola;
    wire [9:0] yi_bola;
    assign xi_bola = x_nave + (45 / 2);
    assign yi_bola = y_nave + 10  - 45/2;
    wire bateu;

    reg CLOCK_MV;
    reg [32:0] contador;

    always @(posedge CLOCK_50) begin //divisor de clock
        contador = contador + 1;
        if (contador >= 320000) begin 
            contador = 0;
            CLOCK_MV = ~CLOCK_MV;
        end
    end 

    nave naveInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .keysout(keysout),
        .reiniciarJogo(0),
        .x_nave(x_nave),
        .y_nave(y_nave),
    );


    // wire [49:0] inimigo_x;
    // wire [49:0] inimigo_y;
    // wire [4:0] inimigo_vivo_array;

    fileira controladorInimigosInstancia(
        .CLOCK_50(CLOCK_50),
        .CLOCK_MV(CLOCK_MV),
        .reset(reset),
        .pausa(pausa),
        .reiniciarJogo(0),
        .bola_nave_x(x_bola_aliada),
        .bola_nave_y(y_bola_aliada),
        .reg_inimigo_x(inimigo_x),
        .reg_inimigo_y(inimigo_y),
        .reg_x_bola(x_bola_inimiga),
        .reg_y_bola(y_bola_inimiga),
        .reg_vivo(inimigo_vivo_array)
    );
    // Atribuindo a posição do primeiro inimigo da fileira
    // assign x_inimigo = inimigo_x[9:0];
    // assign y_inimigo = inimigo_y[9:0];
    // assign inimigo_vivo = inimigo_vivo_array[0];

    // inimigo inimigoInstancia(
    //     .CLOCK_50(CLOCK_50),
    //     .reset(reset),
    //     .pausa(pausa), 
    //     .reiniciarJogo(0),

    //     .xi(20),
    //     .yi(40),

    //     .x(x_inimigo),
    //     .y(y_inimigo),

    //     .bola_nave_x(x_bola_aliada),
    //     .bola_nave_y(y_bola_aliada),
    //     .vivo(inimigo_vivo)
    // );

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