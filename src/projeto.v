module projeto(
    input CLOCK_50,
	input [3:0] KEY, 
    inout [35:0] GPIO_1,
	output VGA_CLK,
	output VGA_SYNC_N,
	output VGA_BLANK_N,
	output VGA_VS,
	output VGA_HS, 
	output [7:0] VGA_R, 
	output [7:0] VGA_G,
	output [7:0] VGA_B 
);  
	assign reset = ~KEY[0];
 
	// VGA
	wire [9:0] xVGA;
	wire [9:0] yVGA;   
	wire vga_ativo;

	//nave
	wire [9:0] xNave;
	wire [9:0] yNave; 
	wire [9:0] larguraNave; 
	wire [9:0] alturaNave;

	tela tela_inst(
		.CLOCK_50(CLOCK_50),
		.reset(reset),
		.xNave(xNave),
		.yNave(yNave),
		.larguraNave(larguraNave), 
		.alturaNave(alturaNave),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK)
	);

	nave nave_inst( 
		.CLOCK_50(CLOCK_50),
		.reset(reset),  
		.xNave(xNave),
		.yNave(yNave), 
		.larguraNave(larguraNave), 
		.alturaNave(alturaNave)
	);
	
endmodule 