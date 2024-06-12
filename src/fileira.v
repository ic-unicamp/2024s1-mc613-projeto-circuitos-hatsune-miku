module fileira(
    input CLOCK_50,
    input CLOCK_MV,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] bola_nave_x,
    input [9:0] bola_nave_y,
    output reg [49:0] reg_inimigo_x, // 5 * 10 bits
    output reg [49:0] reg_inimigo_y, // 5 * 10 bits
    output reg [0:4] reg_vivo        // 5 bits
);
    reg [4:0] i;

    wire [9:0] inimigo_x [0:4];
    wire [9:0] inimigo_y [0:4];
    wire vivo [0:4];

    // Atualização das saídas
    always @(*) begin
        reg_inimigo_x[9 : 0] = inimigo_x[0];
        // reg_inimigo_y[9 : 0] = inimigo_y[0];
        reg_vivo[0] = vivo[0];

        reg_inimigo_x[19 : 10] = inimigo_x[1];
        // reg_inimigo_y[19 : 10] = inimigo_y[1];
        reg_vivo[1] = vivo[1];

        reg_inimigo_x[29 : 20] = inimigo_x[2];
        // reg_inimigo_y[29 : 20] = inimigo_y[2];
        reg_vivo[2] = vivo[2];


        reg_inimigo_x[39 : 30] = inimigo_x[3];
        // reg_inimigo_y[39 : 30] = inimigo_y[3];
        reg_vivo[3] = vivo[4];        
        
        reg_inimigo_x[49 : 40] = inimigo_x[4];
        // reg_inimigo_y[49 : 40] = inimigo_y[4];
        reg_vivo[4] = vivo[4];

    end

    reg sentidoX;

    always @(posedge CLOCK_MV) begin
        if (reset || reiniciarJogo) begin
            sentidoX = 0;
        end else if (!pausa) begin
            for (i = 0; i < 5; i = i + 1) begin
                if (reg_vivo[i]) begin
                    // if (inimigo_x[i] < 20 || inimigo_x[i] + 33 > 640) begin // abaixa
                    //     sentidoX = ~sentidoX;
                    // end
                    if (inimigo_x[0] < 20 || inimigo_x[0] + 33 > 640) begin // abaixa
                        sentidoX = ~sentidoX;
                    end else if (inimigo_x[1] < 20 || inimigo_x[1] + 33 > 640) begin // abaixa
                        sentidoX = ~sentidoX;
                    end else if (inimigo_x[2] < 20 || inimigo_x[2] + 33 > 640) begin // abaixa
                        sentidoX = ~sentidoX;
                    end else if (inimigo_x[3] < 20 || inimigo_x[3] + 33 > 640) begin // abaixa
                        sentidoX = ~sentidoX;
                    end else if (inimigo_x[4] < 20 || inimigo_x[4] + 33 > 640) begin // abaixa
                        sentidoX = ~sentidoX;
                    end
                end
            end
        end
    end

    genvar j;
    generate
        for (j = 0; j < 5; j = j + 1) begin: inimigos
            inimigo inim(
                .CLOCK_50(CLOCK_50),
                .CLOCK_MV(CLOCK_MV),
                .reset(reset),
                .pausa(pausa),
                .reiniciarJogo(reiniciarJogo),
                .xi(100 + j * 100),
                .yi(90),
                .x(inimigo_x[j]),
                .y(inimigo_y[j]),
                .bola_nave_x(bola_nave_x),
                .bola_nave_y(bola_nave_y),
                .sentidoX(sentidoX),
                .vivo(vivo[j])
            );
        end
    endgenerate
endmodule
