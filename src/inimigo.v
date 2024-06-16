module inimigo(
    input CLOCK_50,
    input CLOCK_MV,
    input reset,
    input pausa,
    input reiniciarJogo,
    input [9:0] xi,
    input [9:0] yi,
    output reg [9:0] x,    
    output reg [9:0] y, 
    output [9:0] x_bola,
    output [9:0] y_bola,
    output reg vivo,
    input [9:0] bola_nave_x, 
    input [9:0] bola_nave_y, 
    output [1:0] n_batidas,
    input [9:0] x_nave,
    input [9:0] y_nave,
    input sentidoX
);
    reg [32:0] divisorCLK;
    reg [9:0] largura;
    reg [9:0] altura;
    wire bola_morta;
    assign bola_morta = !vivo;

    assign resetInimigo = reset || reiniciarJogo;


    bolainimiga bolainimigaInstancia(
        .CLOCK_50(CLOCK_50),
        .reset(reset),
        .pausa(pausa),
        .reiniciarJogo(0),
        .xi(x + (33 / 2)),
        .yi(y + 24),
        .x_nave(x_nave),
        .y_nave(y_nave),
        .x(x_bola),
        .y(y_bola),
        .n_batidas(n_batidas),
        .bola_morta(bola_morta)
    );

    always @(posedge CLOCK_50) begin
        if (reset) begin
            vivo = 1;
        end else begin
            if ((x < bola_nave_x) && (bola_nave_x < x + largura) && (y < bola_nave_y) && (bola_nave_y < y + altura)) begin
                vivo = 0;
            end
        end
    end

    reg sentidoAtual;
    reg desceu;
    always @(posedge CLOCK_MV or posedge resetInimigo) begin
        if (resetInimigo) begin
            x = xi;
            y = yi;
            largura = 33;
            altura = 24;
            sentidoAtual = sentidoX;
            desceu = 0;
        end else begin
            if (pausa == 0) begin
                if (sentidoAtual != sentidoX && !desceu) begin // abaixa
                    y = y + 20;
                    sentidoAtual = sentidoX;
                    desceu = 1;
                end else begin
                    desceu = 0;
                end  
                if(sentidoX) begin // direita
                    x = x + 2;
                end else  begin // esquerda
                    x = x - 2;
                end                  
            end
        end
    end

endmodule
