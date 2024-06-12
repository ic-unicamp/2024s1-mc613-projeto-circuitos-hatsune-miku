module display7(
	input CLOCK_50,
    input reset,
    input [9:0] placarAtual,
    input [9:0] placarMaximo,
	output [6:0] HEX0, // digito da direita
  	output [6:0] HEX1,
  	output [6:0] HEX2,
  	output [6:0] HEX3,
  	output [6:0] HEX4,
  	output [6:0] HEX5 // digito da esquerda
);

    reg [3:0] entrada0, entrada1, entrada2, entrada3, entrada4, entrada5;
    reg [20:0] aux;
    
    cb7s decoder_digito0(
        .clk(CLOCK_50),
        .entrada(entrada0),
        .saida(HEX0)
    );
    cb7s decoder_digito1(
        .clk(CLOCK_50),
        .entrada(entrada1),
        .saida(HEX1)
    );
    cb7s decoder_digito2(
        .clk(CLOCK_50),
        .entrada(entrada2),
        .saida(HEX2)
    );
    cb7s decoder_digito3(
        .clk(CLOCK_50),
        .entrada(entrada3),
        .saida(HEX3)
    );
    cb7s decoder_digito4(
        .clk(CLOCK_50),
        .entrada(entrada4),
        .saida(HEX4)
    );
    cb7s decoder_digito5(
        .clk(CLOCK_50),
        .entrada(entrada5),
        .saida(HEX5)
    );

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            entrada0 = 0;
            entrada1 = 10;
            entrada2 = 10;
            entrada3 = 0;
            entrada4 = 10;
            entrada5 = 10;
        end else begin

            entrada0 = placarAtual % 10;
            entrada3 = placarMaximo % 10;

            // não pode ter 0s à esquerda
            // 10 -> não printa
            if (placarAtual >= 100) begin
                aux = placarAtual / 10;
                entrada1 = aux % 10;
                aux = aux / 10;
                entrada2 = aux % 10;

            end else if (placarAtual < 100 && placarAtual >= 10) begin
                aux = placarAtual / 10;
                entrada1 = aux % 10;
                entrada2 = 10;

            end else begin 
                entrada1 = 10;
                entrada2 = 10;
            end

            if (placarMaximo >= 100) begin
                aux = placarMaximo / 10;
                entrada4 = aux % 10;
                aux = aux / 10;
                entrada5 = aux % 10;

            end else if (placarMaximo < 100 && placarMaximo >= 10) begin
                aux = placarMaximo / 10;
                entrada4 = aux % 10;
                entrada5 = 10;

            end else begin 
                entrada4 = 10;
                entrada5 = 10;
            end
        end
    end

endmodule