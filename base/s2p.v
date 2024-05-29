module s2p ( // serial to parallel
    input clk,
    input reset,
    input data_in,
    input enable,
    output reg [15:0] data_out,
    input [3:0] len, 
    output reg ready
);

    reg [4:0] count;

    always @(negedge  clk) begin
        if (reset) begin
            count = 4'b0;
            data_out = 16'h00;   
            ready = 0;
        end else begin
            if (enable) begin
                // data_out[7:1] = data_out[6:0];
                data_out = data_out << 1;
                data_out[0] = data_in;
                
                count = count + 1;

                if (count == len) begin
                    ready = 1;
                end 
            end
        end
    end

endmodule
