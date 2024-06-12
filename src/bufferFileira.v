module bufferFileira(
    input CLK, 
    input reset,
    input [9:0] X_VGA, //recebe já com desconto de 144
    input [9:0] Y_VGA, //recebe já com desconto de 35
    input [49:0] X_OBJETO,
    input [49:0] Y_OBJETO,   
    input [9:0] LARGURA_OBJETO, // pior dos dados LARGURA_OBJETO = 40
    input [9:0] ALTURA_OBJETO, // pior dos dados ALTURA_OBJETO = 40 
    input [3:0] MULTPLICADOR, 
    output R_VGA, // sempre irei retornar o 3 bit mais significativos do RGB
    output G_VGA,  
    output B_VGA,
    output [9:0] LEDR 

);  

    // reg [0:87] buffer_inimigo_R = 88'b0000000000000000000000000000000000001000100000000000000000000000000000000000000000000000;
    // reg [0:87] BUFFER_G = 88'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;
    // reg [0:87] BUFFER_B = 88'b0010000010000010001000001111111000111111111011111111111101111111011010000010100011011000;
    reg [0:87] BUFFER_R = 88'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    reg [0:87] BUFFER_G = 88'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    reg [0:87] BUFFER_B = 88'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
    assign LEDR = LARGURA_OBJETO;

    assign R_VGA = r_0 || r_1 || r_2 || r_3 || r_4;
    assign G_VGA = g_0 || g_1 || g_2 || g_3 || g_4;
    assign B_VGA = b_0 || b_1 || b_2 || b_3 || b_4;

    wire r_0, g_0, b_0, r_1, g_1, b_1, r_2, g_2, b_2, r_3, g_3, b_3, r_4, g_4, b_4;


    buffer buffer_0 (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X),
        .Y_VGA(VGA_Y),
        .X_OBJETO(X_OBJETO[9:0]),
        .Y_OBJETO(Y_OBJETO[9:0]),
        .LARGURA_OBJETO(LARGURA_OBJETO),
        .ALTURA_OBJETO(ALTURA_OBJETO),
        .MULTPLICADOR(MULTPLICADOR),
        .BUFFER_R({BUFFER_R, 312'b0}),
        .BUFFER_G({BUFFER_G, 312'b0}),
        .BUFFER_B({BUFFER_B, 312'b0}),
        .R_VGA(r_0),
        .G_VGA(g_0),
        .B_VGA(b_0)
    );

    buffer buffer_1 (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X),
        .Y_VGA(VGA_Y),
        .X_OBJETO(X_OBJETO[19:10]),
        .Y_OBJETO(Y_OBJETO[19:10]),
        .LARGURA_OBJETO(LARGURA_OBJETO),
        .ALTURA_OBJETO(ALTURA_OBJETO),
        .MULTPLICADOR(MULTPLICADOR),
        .BUFFER_R({BUFFER_R, 312'b0}),
        .BUFFER_G({BUFFER_G, 312'b0}),
        .BUFFER_B({BUFFER_B, 312'b0}),
        .R_VGA(r_1),
        .G_VGA(g_1),
        .B_VGA(b_1)
    );

    buffer buffer_2 (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X),
        .Y_VGA(VGA_Y),
        .X_OBJETO(X_OBJETO[29:20]),
        .Y_OBJETO(Y_OBJETO[29:20]),
        .LARGURA_OBJETO(LARGURA_OBJETO),
        .ALTURA_OBJETO(ALTURA_OBJETO),
        .MULTPLICADOR(MULTPLICADOR),
        .BUFFER_R({BUFFER_R, 312'b0}),
        .BUFFER_G({BUFFER_G, 312'b0}),
        .BUFFER_B({BUFFER_B, 312'b0}),
        .R_VGA(r_2),
        .G_VGA(g_2),
        .B_VGA(b_2)
    );

    buffer buffer_3 (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X),
        .Y_VGA(VGA_Y),
        .X_OBJETO(X_OBJETO[39:30]),
        .Y_OBJETO(Y_OBJETO[39:30]),
        .LARGURA_OBJETO(LARGURA_OBJETO),
        .ALTURA_OBJETO(ALTURA_OBJETO),
        .MULTPLICADOR(MULTPLICADOR),
        .BUFFER_R({BUFFER_R, 312'b0}),
        .BUFFER_G({BUFFER_G, 312'b0}),
        .BUFFER_B({BUFFER_B, 312'b0}),
        .R_VGA(r_3),
        .G_VGA(g_3),
        .B_VGA(b_3)
    );

    buffer buffer_4 (
        .CLK(VGA_CLK),
        .reset(reset),
        .X_VGA(VGA_X),
        .Y_VGA(VGA_Y),
        .X_OBJETO(X_OBJETO[49:40]),
        .Y_OBJETO(Y_OBJETO[49:40]),
        .LARGURA_OBJETO(LARGURA_OBJETO),
        .ALTURA_OBJETO(ALTURA_OBJETO),
        .MULTPLICADOR(MULTPLICADOR),
        .BUFFER_R({BUFFER_R, 312'b0}),
        .BUFFER_G({BUFFER_G, 312'b0}),
        .BUFFER_B({BUFFER_B, 312'b0}),
        .R_VGA(r_4),
        .G_VGA(g_4),
        .B_VGA(b_4)
    );

endmodule