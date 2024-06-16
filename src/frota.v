module frota(
    input CLOCK_50,
    input CLOCK_MV, 
    input reset, 
    input pausa,
    input reiniciarJogo,  
    input [9:0] bola_nave_x,
    input [9:0] bola_nave_y,
    output reg [199:0] reg_inimigo_x, // 5 * 10 bit s
    output reg [199:0] reg_inimigo_y, // 5 * 10 bits 
    output reg [199:0] reg_x_bola, // 5 * 10 bits 
    output reg [199:0] reg_y_bola, // 5 * 10 bits
    output reg [0:19] reg_vivo,        // 5 bits 
    output reg reg_naveMorta,
    output reg [1:0] reg_n_batidas,
    input [9:0] x_nave, 
    input [9:0] y_nave 
);
    reg [4:0] i; 
 
    wire [49:0] inimigo_x [0:3];
    wire [49:0] inimigo_y [0:3];
    wire [49:0] x_bola [0:3]; 
    wire [49:0] y_bola [0:3];
    wire [0:4] vivo [0:3];
    wire [1:0] n_batidas [0:3];
    wire [0:1] naveMorta;

    // Atualização das saídas
    always @(posedge CLOCK_MV) begin
            reg_inimigo_x[49 : 0] = inimigo_x[0];
            reg_inimigo_y[49 : 0] = inimigo_y[0];
            reg_x_bola[49 : 0] = x_bola[0];
            reg_y_bola[49 : 0] = y_bola[0];

            reg_inimigo_x[99 : 50] = inimigo_x[1];
            reg_inimigo_y[99 : 50] = inimigo_y[1];
            reg_x_bola[99 : 50] = x_bola[1];
            reg_y_bola[99 : 50] = y_bola[1];

            reg_inimigo_x[149 : 100] = inimigo_x[2];
            reg_inimigo_y[149 : 100] = inimigo_y[2];
            reg_x_bola[149 : 100] = x_bola[2];
            reg_y_bola[149 : 100] = y_bola[2];


            reg_inimigo_x[199 : 150] = inimigo_x[3];
            reg_inimigo_y[199 : 150] = inimigo_y[3];
            reg_x_bola[199 : 150] = x_bola[3];
            reg_y_bola[199 : 150] = y_bola[3];

            reg_vivo = {vivo[0], vivo[1], vivo[2], vivo[3]};        

            reg_n_batidas = n_batidas[0] + n_batidas[1] + n_batidas[2] + n_batidas[3]; 
            reg_naveMorta = |naveMorta;
    end

    wire [9:0] inimigo_xi [0:3];
    wire [9:0] inimigo_yi [0:3];

    assign inimigo_xi [0] = 110;
    assign inimigo_xi [1] = 60;
    assign inimigo_xi [2] = 110;
    assign inimigo_xi [3] = 60;
 
    assign inimigo_yi [0] = 40;
    assign inimigo_yi [1] = 80;
    assign inimigo_yi [2] = 120;
    assign inimigo_yi [3] = 160;  
   
    genvar r; 
    generate
        for (r = 0; r < 2; r = r + 1) begin: fileira_inst
            fileira fileira_inst(
                .CLOCK_50(CLOCK_50),
                .CLOCK_MV(CLOCK_MV),
                .reset(reset), 
                .pausa(pausa),
                .reiniciarJogo(reiniciarJogo),
                .inimigo_xi(inimigo_xi[r]),
                .inimigo_yi(inimigo_yi[r]),
                .reg_inimigo_x(inimigo_x[r]),
                .reg_inimigo_y(inimigo_y[r]),
                .reg_x_bola(x_bola[r]),
                .reg_y_bola(y_bola[r]),
                .reg_vivo(vivo[r]),
                .reg_naveMorta(naveMorta[r]),
                .bola_nave_x(bola_nave_x),
                .bola_nave_y(bola_nave_y),
                .reg_n_batidas(n_batidas[r]),
                .x_nave(x_nave),
                .y_nave(y_nave),
                .trocarSentido(trocarSentido)
            );
        end
    endgenerate
endmodule
