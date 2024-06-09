module vga(
  input CLOCK_50,
  input reset,
  output reg VGA_CLK,
  output VGA_HS,
  output VGA_VS, 
  output VGA_BLANK_N,
  output VGA_SYNC_N,
  output reg [9:0] x,
  output reg [9:0] y,
  output wire ativo
);

// Divisor de frequência para gerar o clock da VGA
always @(posedge CLOCK_50) begin
  if (reset) begin
    VGA_CLK = 1'b0;
  end else begin
    VGA_CLK = ~VGA_CLK;
  end
end

always @(posedge VGA_CLK) begin
  x = x + 1;
  if (x >= 800) begin
    x = 0;
    y = y + 1;
    if (y >= 525) begin // verificar limite
      y = 0;
    end
  end
end

	assign VGA_HS = (x < 96) ? 0 : 1; 
	assign VGA_VS = (y < 2) ? 0 : 1; 
	assign VGA_BLANK_N = 1;
	assign VGA_SYNC_N = 0;
	assign ativo = (x >= 144) && (x < 784) && (y >= 35) && (y < 515) && (!reset) ? 1 : 0;

endmodule
