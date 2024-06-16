module lfsr(
	input clk,
	input reset,
	input [9:0] seed,
	output reg [9:0] lfsrRegister
);
	always@(posedge clk or posedge reset) begin
		if (reset) begin
			lfsrRegister = seed;
		end else begin
			// lfsrRegister = lfsrRegister << 1;
			// lfsrRegister[0] = lfsrRegister[9] ^ lfsrRegister[6] ^ lfsrRegister[5] ^ lfsrRegister[4];
			lfsrRegister = {lfsrRegister[8:0], lfsrRegister[9] ^ lfsrRegister[6]};
		end
	end
endmodule