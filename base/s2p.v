module s2p (
    input clk,
    input reset,
    input data_in,
    input enable,
    output reg [15:0] data_out,
    input [3:0] len, 
    output reg ready
);

    reg [4:0] count;  

    always @(negedge clk or posedge reset) begin 
        if (reset) begin
            count <= 4'h0;
            data_out <= 16'h0000;   
            ready <= 0;   
        end else begin 
            if (enable) begin
                if (count == 0) begin
                    data_out <= 16'h0000;  // Reset data_out at the beginning of a new read
                end
                if (count == len - 1) begin  
                    ready <= 1;
                end else begin
                    data_out <= {data_out[14:0], data_in};
                    count <= count + 1;
                end 
            end else begin
                ready <= 0;
                count <= 4'h0;
            end
        end
    end

endmodule
