module tela(
    input VGA_CLK, 
    input CLOCK_50,
	input reset, 
	input ativo, 
	input perdeu,  
    input [1:0] vidas,

	input [9:0] x_bola_aliada,  
	input [9:0] y_bola_aliada, 
	input [9:0] raio_bola_aliada,    
	input [9:0] raio_bola_inimiga,      
   
	input [9:0] x_nave,          
	input [9:0] y_nave,                
             
    input [49:0] inimigo_x,  
    input [49:0] inimigo_y,  
    input [49:0] x_bola_inimiga, 
    input [49:0] y_bola_inimiga, 
    input [0:4] inimigo_vivo_array, 

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
    wire [32:0] delta_inimigo_x_1, delta_inimigo_x_2, delta_inimigo_x_3, delta_inimigo_x_4, delta_inimigo_x_5;
    wire [32:0] delta_inimigo_y_1, delta_inimigo_y_2, delta_inimigo_y_3, delta_inimigo_y_4, delta_inimigo_y_5;
    wire [9:0] raioquadrado_inimigo;
    assign raioquadrado_inimigo = raio_bola_inimiga ** 2;

    // bola_inimigo_1
    assign delta_inimigo_x_1 = (x_bola_inimiga[9:0] + 144 - VGA_X) ** 2;
    assign delta_inimigo_y_1 = (y_bola_inimiga[9:0] + 35 - VGA_Y) ** 2;

    // bola_inimigo_2
    assign delta_inimigo_x_2 = (x_bola_inimiga[19:10] + 144 - VGA_X) ** 2;
    assign delta_inimigo_y_2 = (y_bola_inimiga[19:10] + 35 - VGA_Y) ** 2;

    // bola_inimigo_3
    assign delta_inimigo_x_3 = (x_bola_inimiga[29:20] + 144 - VGA_X) ** 2;
    assign delta_inimigo_y_3 = (y_bola_inimiga[29:20] + 35 - VGA_Y) ** 2;

    // bola_inimigo_4
    assign delta_inimigo_x_4 = (x_bola_inimiga[39:30] + 144 - VGA_X) ** 2;
    assign delta_inimigo_y_4 = (y_bola_inimiga[39:30] + 35 - VGA_Y) ** 2;

    // bola_inimigo_5
    assign delta_inimigo_x_5 = (x_bola_inimiga[49:40] + 144 - VGA_X) ** 2;
    assign delta_inimigo_y_5 = (y_bola_inimiga[49:40] + 35 - VGA_Y) ** 2;
    

    //inimigo __________________________________________________________________________________
    reg [3:0] multiplicador_inimigo;
    reg [9:0] largura_inimigo_imagem;
    reg [9:0] altura_inimigo_imagem;
    reg [0:87] BUFFER_R = 88'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    reg [0:87] BUFFER_G = 88'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;
    reg [0:87] BUFFER_B = 88'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    wire [4:0] r_inimigo, g_inimigo, b_inimigo;
    wire [9:0] matrix_inimigo_x [0:4];
    wire [9:0] matrix_inimigo_y [0:4];

    assign matrix_inimigo_x[0] = inimigo_x[9:0];
    assign matrix_inimigo_x[1] = inimigo_x[19:10];
    assign matrix_inimigo_x[2] = inimigo_x[29:20];
    assign matrix_inimigo_x[3] = inimigo_x[39:30];
    assign matrix_inimigo_x[4] = inimigo_x[49:40];

    assign matrix_inimigo_y[0] = inimigo_y[9:0];
    assign matrix_inimigo_y[1] = inimigo_y[19:10];
    assign matrix_inimigo_y[2] = inimigo_y[29:20];
    assign matrix_inimigo_y[3] = inimigo_y[39:30];
    assign matrix_inimigo_y[4] = inimigo_y[49:40];

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin: buffers
            buffer inimigo_inst (
                .CLK(VGA_CLK),
                .reset(reset),
                .X_VGA(VGA_X - 144),
                .Y_VGA(VGA_Y - 35),
                .X_OBJETO(matrix_inimigo_x[i]),  // Extrai 10 bits começando do bit 10*i
                .Y_OBJETO(matrix_inimigo_y[i]),  // Extrai 10 bits começando do bit 10*i
                .LARGURA_OBJETO(largura_inimigo_imagem),
                .ALTURA_OBJETO(altura_inimigo_imagem),
                .MULTPLICADOR(multiplicador_inimigo),
                .BUFFER_R({BUFFER_R, 312'b0}),
                .BUFFER_G({BUFFER_G, 312'b0}),
                .BUFFER_B({BUFFER_B, 312'b0}),
                .R_VGA(r_inimigo[i]),
                .G_VGA(g_inimigo[i]),
                .B_VGA(b_inimigo[i])
            );
        end
    endgenerate

    // nave _______________________________________________________________________________________________________________--

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
        .BUFFER_R({buffer_nave_R, 146'b0}),
        .BUFFER_G({buffer_nave_G, 146'b0}),
        .BUFFER_B({buffer_nave_B, 146'b0}),
        .R_VGA(nave_r),
        .G_VGA(nave_g),
        .B_VGA(nave_b)
    );

    // coracao _______________________________________________________________________________________________________________
    reg [3:0] multiplicador_coracao;
    reg [9:0] largura_coracao_imagem;
    assign largura_coracao = largura_coracao_imagem * multiplicador_coracao;
    reg [0:99] buffer_coracao_R = 100'b0011001100011111111011111111111111111111111111111101111111100011111100000111100000001100000000000000;
    reg [0:99] buffer_coracao_G = 100'b0011001100010011001010000001011000000001100000000101000000100010000100000100100000001100000000000000;
    reg [0:99] buffer_coracao_B = 100'b0011001100010011001010000001011000000001100000000101000000100010000100000100100000001100000000000000;
    wire [4:0] coracao_r, coracao_g, coracao_b;
	 
    genvar j;
    generate
        for (j = 0; j < 3; j = j + 1) begin: buffers_coracao
            buffer coracao_inst (
                .CLK(VGA_CLK),
                .reset(reset),
                .X_VGA(VGA_X - 144),
                .Y_VGA(VGA_Y - 35) ,
                .X_OBJETO(20 + j * 40),
                .Y_OBJETO(5),
                .LARGURA_OBJETO(largura_coracao_imagem),
                .ALTURA_OBJETO(largura_coracao_imagem),
                .MULTPLICADOR(multiplicador_coracao),
                .BUFFER_R({buffer_coracao_R, 300'b0}),
                .BUFFER_G({buffer_coracao_G, 300'b0}),
                .BUFFER_B({buffer_coracao_B, 300'b0}),
                .R_VGA(coracao_r[j]),
                .G_VGA(coracao_g[j]),
                .B_VGA(coracao_b[j])
            );
        end
    endgenerate

    //fundo _______________________________________________________________________________________________________________
    wire fundo_r, fundo_g, fundo_b;
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

    // game over _______________________________________________________________________________________________________________
    reg [0:3071]  buffer_game_over = 3072'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111011111010001011111000011111010001011111011111000000000000001000001000101101101000000001000101000101000001000100000000000000101110111110101010111110000100010100010111110111110000000000000010001010001010001010000000010001001010010000010010000000000000001111101000101000101111100001111100010001111101000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    wire [32:0] indice;
    assign indice = (VGA_Y - 35) / 10 * (64) + ((VGA_X - 144) / 10);

    always @(negedge VGA_CLK or posedge reset) begin // implementar a lógica que será usada para "imprimir" na tela
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
            if (ativo) begin
                if (!perdeu) begin
                    if (delta_x_aliado + delta_y_aliado < raioquadrado_aliado) begin // bola aliada
                        VGA_R <= 255;
                        VGA_G <= 255;
                        VGA_B <= 255;
                    end else if (delta_inimigo_x_1 + delta_inimigo_y_1 < raioquadrado_inimigo) begin // bola aliada
                        VGA_R <= 255; 
                        VGA_G <= 0;
                        VGA_B <= 0;
                    end else if (delta_inimigo_x_2 + delta_inimigo_y_2 < raioquadrado_inimigo) begin // bola aliada
                        VGA_R <= 255;
                        VGA_G <= 0;
                        VGA_B <= 0;
                    end else if (delta_inimigo_x_3 + delta_inimigo_y_3 < raioquadrado_inimigo) begin // bola aliada
                        VGA_R <= 255;
                        VGA_G <= 0;
                        VGA_B <= 0;
                    end else if (delta_inimigo_x_4 + delta_inimigo_y_4 < raioquadrado_inimigo) begin // bola aliada
                        VGA_R <= 255;
                        VGA_G <= 0;
                        VGA_B <= 0;
                    end else if (delta_inimigo_x_5 + delta_inimigo_y_5 < raioquadrado_inimigo) begin // bola aliada
                        VGA_R <= 255;
                        VGA_G <= 0;
                        VGA_B <= 0;
                    end else if (inimigo_vivo_array[0] && (r_inimigo[0] || g_inimigo[0] || b_inimigo[0])) begin // inimigos
                        VGA_R <= r_inimigo[0] * 255;
                        VGA_G <= g_inimigo[0] * 255;
                        VGA_B <= b_inimigo[0] * 255;
                    end else if (inimigo_vivo_array[1] && (r_inimigo[1] || g_inimigo[1] || b_inimigo[1])) begin // inimigos
                        VGA_R <= r_inimigo[1] * 255;
                        VGA_G <= g_inimigo[1] * 255;
                        VGA_B <= b_inimigo[1] * 255;
                    end else if (inimigo_vivo_array[2] && (r_inimigo[2] || g_inimigo[2] || b_inimigo[2])) begin // inimigos
                        VGA_R <= r_inimigo[2] * 255;
                        VGA_G <= g_inimigo[2] * 255;
                        VGA_B <= b_inimigo[2] * 255;
                    end else if (inimigo_vivo_array[3] && (r_inimigo[3] || g_inimigo[3] || b_inimigo[3])) begin // inimigos
                        VGA_R <= r_inimigo[3] * 255;
                        VGA_G <= g_inimigo[3] * 255;
                        VGA_B <= b_inimigo[3] * 255;
                    end else if (inimigo_vivo_array[4] && (r_inimigo[4] || g_inimigo[4] || b_inimigo[4])) begin // inimigos
                        VGA_R <= r_inimigo[4] * 255;
                        VGA_G <= g_inimigo[4] * 255;
                        VGA_B <= b_inimigo[4] * 255;
                    end else if (nave_r || nave_g || nave_b) begin // nave
                        VGA_R <= nave_r * 255;
                        VGA_G <= nave_g * 255;
                        VGA_B <= nave_b * 255;
                    end else if ((vidas > 0) && coracao_r[0] || coracao_g[0] || coracao_b[0]) begin // coracao
                        VGA_R <= coracao_r[0] * 255;
                        VGA_G <= coracao_g[0] * 255;
                        VGA_B <= coracao_b[0] * 255;
                    end else if ((vidas > 1) && coracao_r[1] || coracao_g[1] || coracao_b[1]) begin // coracao
                        VGA_R <= coracao_r[1] * 255;
                        VGA_G <= coracao_g[1] * 255;
                        VGA_B <= coracao_b[1] * 255;
                    end else if ((vidas > 2) && (coracao_r[2] || coracao_g[2] || coracao_b[2])) begin // coracao
                        VGA_R <= coracao_r[2] * 255;
                        VGA_G <= coracao_g[2] * 255;
                        VGA_B <= coracao_b[2] * 255;
                    end else begin
                        if (fundo_r || fundo_g || fundo_b) begin
                            VGA_R <= fundo_r * 255; 
                            VGA_G <= fundo_g * 255;
                            VGA_B <= fundo_b * 255;
                        end else begin 
                            VGA_R <= 0;
                            VGA_G <= 0;
                            VGA_B <= 0;  
                        end
                    end
                end else begin
                    if (buffer_game_over[indice] == 1) begin
                        VGA_R = 255;
                        VGA_G = 255;
                        VGA_B = 255;
                    end else begin
                        VGA_R = 255;
                        VGA_G = 0;
                        VGA_B = 0;                   
                    end
                end
            end else begin 
                    VGA_R <= 0;
                    VGA_G <= 0;
                    VGA_B <= 0;  
            end
        end
    end


endmodule