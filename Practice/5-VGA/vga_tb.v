`timescale 1ns/1ns
module vga_tb;
reg clk;

wire disp_R;
wire disp_G;
wire disp_B;
wire vsync;
wire hsync;

vga u1(
	.clock(clk),
	.disp_R(disp_R),
	.disp_G(disp_G),
	.disp_B(disp_B),
	.hsync(hsync),
	.vsync(vsync)
	);
	
initial                                                
begin                                                  
	clk = 0;
	forever #10 clk = ~clk;
end                                                    

endmodule
