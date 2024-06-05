module s2p ( // serial to parallel
    input clk,
    input reset,
    input data_in,
    input enable,
    output reg [15:0] data_out,
    input [3:0] len, 
    output reg ready,
    output reg [4:0] countAUX 
);

    reg [4:0] count; 
 
    always @(negedge clk or posedge reset) begin
        if (reset) begin
            countAUX <= 4'hf;  
        end else begin  
            if (data_in != 0 && enable) begin
                countAUX <= count;
            end
        end
    end 

    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            count <= 4'h0;
            data_out <= 16'h0000;   
            ready <= 0;  
        end else begin 
            if (enable) begin
                if (count == len) begin
                    ready <= 1;
                end else begin
                    data_out <= {data_out[14:0], data_in};
                    count <= count + 1;
                end 
            end else begin
                ready <= 0;
            end
        end
    end

endmodule
