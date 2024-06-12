module placar(
    input CLOCK_50,
    input reset,
    //input bolaRebatida,
    input [999:0] inimigosvida,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3, 
    output [6:0] HEX4,
    output [6:0] HEX5,
	output [9:0] LEDR,
	input perdeuJogo,
	input reiniciarJogo
);

	assign LEDR = placarAtual;
    reg [999:0] inimigosvida_anterior;
    reg [9:0] placarAtual;
	reg [9:0] placarMaximo;
	reg jaBateu;
    reg contador;

	display7 display7Instancia(
		.CLOCK_50(CLOCK_50),
		.reset(reset),
		.placarAtual(placarAtual),
		.placarMaximo(placarMaximo),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5), 
		
	);

    always @(posedge CLOCK_50) begin
        if (reset) begin
            inimigosvida_anterior = inimigosvida;
            contador = 0;
        end else begin
            if (contador < 1000) begin
                if (inimigosvida[contador] != inimigosvida_anterior[contador]) begin
                    //Ganhar 1 ponto
                    placarAtual = placarAtual + 1;
                end
                contador = contador + 1;
            end else begin
                contador = 0;
            end
            if (placarAtual > placarMaximo) begin
                placarMaximo = placarAtual;
            end
            if (placarAtual > 999) begin
                placarAtual = 0;
            end
            inimigosvida_anterior = inimigosvida;
        end

    end


    // always @(posedge CLOCK_50) begin
    //     if (reset) begin
    //         placarAtual <= 0;
    //         placarMaximo <= 0;
	// 		jaBateu <= 0;
    //     end else begin
	// 		if (reiniciarJogo) begin																																			
	// 			placarAtual <= 0;
	// 			jaBateu <= 0;
	// 		end
	// 		if (bolaRebatida && !jaBateu) begin
	// 			placarAtual <= placarAtual + 1;
	// 			jaBateu <= 1;
	// 		end
	// 		if (!bolaRebatida) begin
	// 			jaBateu <= 0;
	// 		end
	// 		if (placarAtual > placarMaximo) begin
	// 			placarMaximo <= placarAtual;
	// 		end
	// 		if (placarAtual > 999) begin
	// 			placarAtual <= 0;
	// 		end
		  
	// 	end
    // end

endmodule