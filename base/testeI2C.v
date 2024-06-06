module testeI2C (    
    input CLOCK_50,            
    output HPS_I2C1_SCLK, // Verificar a frequência máxima, provavelmente usar PLL
    inout HPS_I2C1_SDAT, 
    input HPS_GSENSOR_INT,
    output reg [9:0] LEDR,     
    input [9:0] SW ,       
    output [6:0] HEX0, // digito da direita        
    output [6:0] HEX1,    
    output [6:0] HEX2,            
    output [6:0] HEX3,                        
    output [6:0] HEX4,         
    output [6:0] HEX5 // digito da esquerda   
);      
	    
    wire reset;  
    assign reset = SW[0];
	 
    reg enable_p2s; 
    reg enable_s2p;

    always @(posedge CLOCK_50) begin
        enable_s2p = ~enable_p2s;
    end

    wire done_p2s;
    wire done_s2p;

    reg [15:0] msg_master;
    wire [15:0] msg_slave;

    reg [3:0] len_msg_master;
    reg [3:0] len_msg_slave;

    reg ACK; 

    reg [9:0] count_500; // 100 kHz = 50 MHz / 500

    reg AUX_HPS_I2C1_SCLK;
    assign HPS_I2C1_SCLK = AUX_HPS_I2C1_SCLK;

    reg [3:0] state;

    always @(posedge CLOCK_50) begin // Dividor de clock, AUX_HPS_I2C1_SCLK <= 100KHz
        if (count_500 >= 499) begin
            count_500 <= count_500 + 1;
        end else begin
            count_500 <= 0;
            AUX_HPS_I2C1_SCLK <= ~AUX_HPS_I2C1_SCLK;
        end
    end
 
    // Do HEX2 ao HEX5 usao para mosntar a mensagem que o slave envia
    cb7s decoder_digito5(
        .clk(HPS_I2C1_SCLK),
        .entrada(msg_slave[15:12]),
        .saida(HEX5)
    );

    cb7s decoder_digito4(
        .clk(HPS_I2C1_SCLK),
        .entrada(msg_slave[11:8]),
        .saida(HEX4) 
    );
      
    cb7s decoder_digito3(
        .clk(HPS_I2C1_SCLK),
        .entrada(msg_slave[7:4]),
        .saida(HEX3)
    );

    cb7s decoder_digito2(
        .clk(HPS_I2C1_SCLK),
        .entrada(msg_slave[3:0]),
        .saida(HEX2)
    );

    assign HEX1 = 7'b0111111; // Um traço

    cb7s decoder_digito0( // Mostra o estado onde a maquina parou
        .clk(HPS_I2C1_SCLK),
        .entrada(state),
        .saida(HEX0)
    );

    p2s p2s_inst( // Modulo que faz o envio na serial
        .clk(HPS_I2C1_SCLK),
        .reset(reset),
        .data_in(msg_master),
        .len(len_msg_master),
        .enable(enable_p2s),
        .data_out(HPS_I2C1_SDAT),
        .done(done_p2s)
    );

    s2p s2p_inst( // Modulo que que reccebe pela serial
        .clk(HPS_I2C1_SCLK),
        .reset(reset),
        .data_in(HPS_I2C1_SDAT),
        .len(len_msg_slave),
        .enable(enable_s2p),
        .data_out(msg_slave),
        .ready(done_s2p)
    );


    always @(posedge HPS_I2C1_SCLK) begin
        if (reset) begin
            state <= 4'b0000;
            enable_p2s <= 1;
            len_msg_slave <= 4'h0;
            ACK <= 1'b0;
            msg_master <= 16'h4000; // Start
            len_msg_master <= 4;
            enable_clk <= 0;
    end else begin
            case (state)

                4'b0000: begin // Envia o start
                    if (done_p2s) begin
                        enable_p2s <= 0;
                        len_msg_slave <= 4'h0;
                        state <= 4'b0001;
                        enable_clk <= 1;
                    end
                end

                4'b0001: begin // Aguarda um clock
                    msg_master <= 16'h5300; // Slave Address + W (0000) A6 A7 53
                    len_msg_master <= 4'h09;
                    state <= 4'b0010; //envio
                    enable_p2s <= 1;
                end

                4'b0010: begin // envia slave address + write
                    if (done_p2s) begin
                        enable_p2s <= 0;
                        len_msg_slave <= 4'h1;
                        state <= 4'b0011;
                    end
                end

                4'b0011: begin // Aguarda o ACK
                     if (done_s2p) begin 
                        if (msg_slave[0] == ACK) begin // ACK
                            len_msg_slave <= 4'h1;
                            enable_p2s <= 1;
                            state <= 4'b0100;
                            msg_master <= 16'h3100; // registrador DATA_FORMAT
                            len_msg_master <= 4'h08;
                        end else begin // Deu errado
                            enable_p2s <= 1; 
                            state <= 4'b1111;
                        end
                    end
                end

                4'b0100: begin // Envia o endero do registrador TALVEZ TENHA ERRO 
                     if (done_p2s) begin
                        enable_p2s <= 0;
                        state <= 4'b0101;
                        len_msg_slave <= 4'h1;
                    end
                end

                4'b0101: begin // Aguarda o ACK
                     if (done_s2p) begin 
                        if (msg_slave[0] == ACK) begin 
                            state <= 4'b0110;
                            enable_p2s <= 1;
                            msg_master <= 16'h4000; // restart ANALIZAR ISSO E O START
                            len_msg_master <= 4'h2;
                        end else begin // Deu errado
                            enable_p2s <= 1;
                            state <= 4'b1111;
                        end
                    end
                end

                4'b0110: begin // Envia o restart
                    if (done_p2s) begin
                        enable_p2s <= 0;
                        state <= 4'b0111;
                    end
                end

                4'b0111: begin // Aguarda um clock
                    state <= 4'b1000; //envio
                    msg_master <= 16'h2C80; // BW_RATE + R (1000) 
                    len_msg_master <= 4'h09;
                    enable_p2s <= 1;
                end

                4'b1000: begin // envia BW_RATE + R
                    if (done_p2s) begin
                        enable_p2s <= 0;
                        state <= 4'b1001;
                        len_msg_slave <= 4'h1;
                    end
                end

                4'b1001: begin // Aguarda o ACK
                    if (done_s2p) begin 
                        if (msg_slave[0] == ACK) begin // ACK
                            enable_p2s <= 1;
                            state <= 4'b1010;
                        end else begin // Deu errado
                            enable_p2s <= 1;
                            state <= 4'b1111;
                        end
                    end
                end

                4'b1010: begin // Aguarda um clock
                    len_msg_slave <= 4'h8;
                    enable_p2s <= 0; //ativa o s2p
                    state <= 4'b1011; //envio
                end

                4'b1011: begin // leio 8 bits
                    if (done_s2p) begin 
                        state <= 4'b1100;
                    end
                end

                4'b1100: begin 
                    state <= 4'b1100;
                end

                4'b1110: begin // teste
                    state <= 4'b1110;
                end

                4'b1111: begin // != ACK 
                    state <= 4'b1111;
                end

                default: state <= 4'b1111;
            endcase
        end
    end
endmodule
    /*
        Não esquecer do mux

        SYSMGR_I2C0USEFPGA = 0;
        SYSMGR_GENERALIO7 = 1;
        SYSMGR_GENERALIO8 = 1;
    */

    /* Visão geral
        R ~W, chuto que 1 é leitura e 0 é escrita

        sempre envio do mias significativo para o menos significativo

        start = 4'b0100

        0x32 DATAX0, parte do x menos significativa
        0x33 DATAX1, parte mais sifnificativa do x

        0x34 DATAY0
        0x35 DATAY1

        0x36 DATAZO
        0x37 DATAZ1

        init:
            0x31 DATA_FORMAT <= 8'b0000.0100 + 8'b00000011 // full_res + 16g
            0x2C BW_RATE <= 8'h0B
            0x24 THRESH_ACT <= 0x04
            0x25 THRESH_INACT <= 0x02
            0x26 TIME_INACT <= 0x02
            0x27 ACT_INACT_CTL <= 0xFF
            0x2D POWER_CTL <= 0x00 //stop
            0x2D POWER_CTL <= 0x08 //start do sensor

        I2C0_RXFLR indica a quantidade de dados a serem lidos do slave, MAS NÃO TEM NO PINOUT
    */

    /* Sequência
        mux
        init

        comunicação de multiplas leituras
            * Por padrão sempre mandamos star [0x400] + 0xA6/0xA7, para iniciar o i2c, informar que o dispositivos que desejamos comunicar é o 0xA6/0xA7, um bit W e esperamos o sinal ACK, que viŕa do slave

            * apos isso indicamos o address que desejaos ler e esperamos novamente o ack, após esse sinal damos um stop e um star

            * novamente enviamos 0xA6/0xA7, para iniciar o i2c, informar que o dispositivos que desejamos comunicar é o 0xA6/0xA7, um bit R de Resperamos o sinal ACK, que viŕa do slave

            * agora é p slava que irá enviar os dados, assim que recebemso o dado enviamos o ack para o slave se deu certo, caso contraio o nack, se der certo ele enviara 6 dados, por fim enviamos um stop

        irei tentar fazer 6 leituras simples depois tento fazer multiplas leituras

    */

     // Send read signal, será que é 4b'0001?
     // *I2C0_DATA_CMD = 0x100; 

// endmodule