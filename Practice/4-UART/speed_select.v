
module speed_select(
				clk,rst_n,
				bps_start,clk_bps
			);

input clk;	// 50MHz
input rst_n;	
input bps_start;
output clk_bps;	

/*
parameter 		bps9600 	= 5207,	//9600bps
			 	bps19200 	= 2603,	//19200bps
				bps38400 	= 1301,	// 38400bps
				bps57600 	= 867,	// 57600bps
				bps115200	= 433;	// 115200bps

parameter 		bps9600_2 	= 2603,
				bps19200_2	= 1301,
				bps38400_2	= 650,
				bps57600_2	= 433,
				bps115200_2 = 216;  
*/

	 
`define		BPS_PARA		5207	 // 50MHz / 9600 = 5208.33,5208 - 0-5207
`define 	BPS_PARA_2		2603	 

reg[12:0] cnt;			 
reg clk_bps_r;			 

//----------------------------------------------------------
reg[2:0] uart_ctrl;	// uart 
//----------------------------------------------------------

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if((cnt == `BPS_PARA) || !bps_start) cnt <= 13'd0;	 
	else cnt <= cnt+1'b1;			 

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
 
	else if(cnt == `BPS_PARA_2 && bps_start) clk_bps_r <= 1'b1;	 
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule



