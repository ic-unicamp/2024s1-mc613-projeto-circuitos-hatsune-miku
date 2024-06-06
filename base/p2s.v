module p2s ( // parallel to serial
    input clk,
    input reset,
    input [15:0] data_in, // a informação para ser enviada deve estar na parte mais significativa
    input [3:0] len, 
    input enable,
    output data_out,
    output reg done
);

    reg [3:0] count;
    reg aux_data_out;
    
    wire [3:0] posicao;
    assign posicao = 4'hf - count;
     
    // Tri-state buffer control
    assign data_out = enable ? aux_data_out : 1'bz; // tri-state, sempre que não estou enviando dados, ele deixa em alta impedância

    always @ (posedge clk or posedge reset) begin
        if (reset) begin 
            done = 0; 
            aux_data_out = 1'bz;
            count = 4'h0;
        end else begin
            if (enable) begin
                if (count <= len) begin
                    if (count == len - 4'h1) begin // Verifica se está enviando o último bit
                        aux_data_out = data_in[posicao];
                        count = 4'h0;
                        done = 1;
                    end else begin
                        aux_data_out = data_in[posicao]; 
                        count = count + 4'h1;
                        done = 0;
                    end
                end
            end else begin
                done = 0;
                count = 4'h0;
            end
        end
    end

endmodule
