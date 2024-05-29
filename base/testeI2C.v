/*
    possíveis problemas:
        questão do mux
        qual pino uso, ver a declaração do modulo
        endereço do sensor
		  orsem que envio os bits
		  sinal start
*/

module testeI2C (
    input CLOCK_50,

    output HPS_I2C1_SCLK, // Verificar a frequência máxima, provavelmente usar PLL
    inout HPS_I2C1_SDAT, 

    // output FPGA_I2C_SCLK, // Verificar a frequência máxima, provavelmente usar PLL
    // inout FPGA_I2C_SDAT,
 
    output HPS_LTC_GPIO,
    input [8:0] endereco,
    inout [8:0] info, 
    input enable_write,
    output reg [9:0] LEDR, 
    input [9:0] SW  
); 
	 assign HPS_LTC_GPIO = 1;
	 
	 wire reset;
	 assign reset = SW[0];
	 
    reg enable_p2s; 
    wire done_p2s;
    reg enable_s2p;  
    wire done_s2p;

    reg [15:0] msg_master;
    wire [15:0] msg_slave;

    reg [4:0] len_msg_master;
    reg [4:0] len_msg_slave;

    reg enable_envio;
    reg enable_receber;

    reg clk_200;

	pll pll_inst(
		.refclk(CLOCK_50),
		.rst(reset),
		.outclk_0(clk_200)
    );
    reg AUX_HPS_I2C1_SCLK;
    assign HPS_I2C1_SCLK = AUX_HPS_I2C1_SCLK;
    always @(clk_200) begin
        AUX_HPS_I2C1_SCLK = ~AUX_HPS_I2C1_SCLK;
    end
	 
    p2s p2s_inst(
        .clk(HPS_I2C1_SCLK),
        .reset(reset),
        .data_in(msg_master),
        .len(len_msg_master),
        .enable(enable_p2s),
        .data_out(HPS_I2C1_SDAT),
        .done(done_p2s)
    );

    s2p s2p_inst( 
        .clk(HPS_I2C1_SCLK),
        .reset(reset),
        .data_in(HPS_I2C1_SDAT),
        .len(len_msg_slave),
        .enable(enable_s2p),
        .data_out(msg_slave),
        .ready(done_s2p) 
    );

    reg [3:0] state;
    reg [3:0] jump; // Irei usar o mesmo estado para esperar e ele fará state = jump;

    always @(posedge HPS_I2C1_SCLK) begin
        if (reset) begin
            state <= 4'b0001;
            jump <= 4'b0001;
            enable_envio <= 1;
            enable_receber <= 0;
				LEDR[0] <= 1; 
				LEDR[9] <= 0;
        end else begin
            case (state)

                4'b0000: begin // Aguarda o ACK
                    if (enable_receber && !done_s2p) begin 
                        len_msg_slave <= 16;
                        enable_s2p <= 1;
                        if (msg_slave != 0) begin // ACK
                            LEDR[9] <= 1; 
                            enable_receber <= 0;
                            state <= jump;
                        end
                    end
                end

                4'b0001: begin // Iniciar o sensor
                    if (enable_envio && !done_p2s) begin
                        msg_master <= 16'h4000; // Start
                        len_msg_master <= 4;
                        enable_p2s <= 1;
                    end else if (enable_envio && done_p2s) begin
                        enable_envio <= 0;
                        enable_receber <= 0;
                        state <= 4'b0010;
                    end
					 end

                4'b0010: begin // Aguarda um clock
                        state <= 4'b0011;
                end
                
                4'b0011: begin //slave address + write
                    if (enable_envio && !done_p2s) begin
                        msg_master <= 16'hA780; // Slave Address + W (0100) A6 A7 53
                        len_msg_master <= 9;
                        enable_p2s <= 1;
                    end else if (enable_envio && done_p2s) begin
                        enable_envio <= 0;
                        enable_receber <= 1;
                        state <= 4'b0000;
                        jump <= 4'b0001;
                    end
                end
                
                default: state <= 4'b0000;
            endcase
				LEDR[0] <= 0;
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
            0x31 DATA_FORMAT <= 8'b00000100 + 8'b00000011 // full_res + 16g
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