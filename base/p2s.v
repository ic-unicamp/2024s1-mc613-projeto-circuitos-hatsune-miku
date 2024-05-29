module p2s ( // parallel to serial
    input clk,
    input reset,
    input [15:0] data_in, // a informação para ser enviada deve estar na parte mais significativa
    input [3:0] len, 
    input enable,
    output data_out,
    output reg done
);

    reg [4:0] posicao;
    reg aux_data_out;
    
    // Tri-state buffer control
    assign data_out = enable ? aux_data_out : 1'bz; // tri-state, sempre que não estou enviando dados, ele deixa em alta impedância

    always @ (posedge clk or posedge reset) begin
        if (reset) begin 
            posicao <= 4'b1111; 
            done <= 0;
            aux_data_out <= 1'bz;
        end else begin
            if (enable) begin
                if (posicao >= (16 - len)) begin
                    aux_data_out <= data_in[posicao];
                    posicao <= posicao - 1; 

                    if (posicao == (16 - len)) begin // Verifica se está enviando o último bit
                        done <= 1;
                    end else begin
                        done <= 0;
                    end
                end
            end else begin
                done <= 0;
            end
        end
    end

endmodule
