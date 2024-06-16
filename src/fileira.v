module fileira(
    input CLOCK_50,
    input CLOCK_MV,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] bola_nave_x,
    input [9:0] bola_nave_y,
    input [9:0] inimigo_xi, // 5 * 10 bits
    input [9:0] inimigo_yi, // 5 * 10 bits
    output reg [49:0] reg_inimigo_x, // 5 * 10 bits
    output reg [49:0] reg_inimigo_y, // 5 * 10 bits
    output reg [49:0] reg_x_bola, // 5 * 10 bits
    output reg [49:0] reg_y_bola, // 5 * 10 bits
    output reg [0:4] reg_vivo,        // 5 bits
    output reg [1:0] reg_n_batidas,
    input [9:0] x_nave,
    input [9:0] y_nave,
    input trocarSentido
);
    reg [4:0] i;
    reg sentidoX;

    wire [9:0] inimigo_x [0:4];
    wire [9:0] inimigo_y [0:4];
    wire [9:0] x_bola [0:4];
    wire [9:0] y_bola [0:4];
    wire vivo [0:4];
    wire [1:0] n_batidas [0:4];

    // Atualização das saídas
    always @(posedge CLOCK_MV) begin
            reg_inimigo_x[9 : 0] = inimigo_x[0];
            reg_inimigo_y[9 : 0] = inimigo_y[0];
            reg_x_bola[9 : 0] = x_bola[0];
            reg_y_bola[9 : 0] = y_bola[0];
            reg_vivo[0] = vivo[0];

            reg_inimigo_x[19 : 10] = inimigo_x[1];
            reg_inimigo_y[19 : 10] = inimigo_y[1];
            reg_x_bola[19 : 10] = x_bola[1];
            reg_y_bola[19 : 10] = y_bola[1];
            reg_vivo[1] = vivo[1];

            reg_inimigo_x[29 : 20] = inimigo_x[2];
            reg_inimigo_y[29 : 20] = inimigo_y[2];
            reg_x_bola[29 : 20] = x_bola[2];
            reg_y_bola[29 : 20] = y_bola[2];
            reg_vivo[2] = vivo[2];


            reg_inimigo_x[39 : 30] = inimigo_x[3];
            reg_inimigo_y[39 : 30] = inimigo_y[3];
            reg_x_bola[39 : 30] = x_bola[3];
            reg_y_bola[39 : 30] = y_bola[3];
            reg_vivo[3] = vivo[3];        
            
            reg_inimigo_x[49 : 40] = inimigo_x[4];
            reg_inimigo_y[49 : 40] = inimigo_y[4];
            reg_x_bola[49 : 40] = x_bola[4];
            reg_y_bola[49 : 40] = y_bola[4];
            reg_vivo[4] = vivo[4];

            reg_n_batidas = n_batidas[0] + n_batidas[1] + n_batidas[2] + n_batidas[3] + n_batidas[4]; 
    end

    always @(negedge CLOCK_MV) begin
        if (reset || reiniciarJogo) begin
            sentidoX = 0;
        end else if (!pausa) begin
            if (reg_vivo[0] && (inimigo_x[0] < 5 || inimigo_x[0] + 33 > 640)) begin // abaixa
                sentidoX = ~sentidoX;
            end else if (reg_vivo[1] && (inimigo_x[1] < 5 || inimigo_x[1] + 33 > 640)) begin // abaixa
                sentidoX = ~sentidoX;
            end else if (reg_vivo[2] && (inimigo_x[2] < 5 || inimigo_x[2] + 33 > 640)) begin // abaixa
                sentidoX = ~sentidoX;
            end else if (reg_vivo[3] && (inimigo_x[3] < 5 || inimigo_x[3] + 33 > 640)) begin // abaixa
                sentidoX = ~sentidoX;
            end else if (reg_vivo[4] && (inimigo_x[4] < 5 || inimigo_x[4] + 33 > 640)) begin // abaixa
                sentidoX = ~sentidoX;
            end 
        end
    end

    genvar k;
    generate
        for (k = 0; k < 5; k = k + 1) begin: inimigos
            inimigo inim(
                .CLOCK_50(CLOCK_50),
                .CLOCK_MV(CLOCK_MV),
                .reset(reset),
                .pausa(pausa),
                .reiniciarJogo(reiniciarJogo),
                .xi(inimigo_xi + k * 80),
                .yi(inimigo_yi),
                .x(inimigo_x[k]),
                .y(inimigo_y[k]),
                .x_bola(x_bola[k]),
                .y_bola(y_bola[k]),
                .vivo(vivo[k]),
                .bola_nave_x(bola_nave_x),
                .bola_nave_y(bola_nave_y),
                .n_batidas(n_batidas[k]),
                .x_nave(x_nave),
                .y_nave(y_nave),
                .sentidoX(sentidoX)
            );
        end
    endgenerate
endmodule
