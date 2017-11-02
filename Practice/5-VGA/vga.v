/*

	vga 60Hz: the frequency of line(horizontal) is 32.15kHz(spec.)
				 thus, the max pixel can be caculated as below:
				 (1/core freq.)*pixel = line freq.
				 (1/25MHz)*pixel = 32.15kHz,
				 pixel = 800(max)
*/


module vga(clock,disp_R,disp_G,disp_B,hsync,vsync);

input  clock;    

output disp_R;
output disp_G;
output disp_B;   
output  hsync;     
output  vsync;  

reg [9:0] hcount;    
reg [9:0]   vcount;     
wire  data_R;
wire  data_G;
wire  data_B;
reg [2:0]  h_dat;
reg [2:0]   v_dat;

reg   flag;
wire  hcount_ov;
wire  vcount_ov;
wire  dat_act;
wire  hsync;
wire   vsync;
reg  vga_clk;


parameter hsync_end   = 10'd95,
   hdat_begin  = 10'd143,
   hdat_end  = 10'd783,
   hpixel_end  = 10'd799,
   vsync_end  = 10'd1,
   vdat_begin  = 10'd34,
   vdat_end  = 10'd514,
   vline_end  = 10'd524;


always @(posedge clock)
begin
 vga_clk = ~vga_clk;   // 1/2 clk
end

always @(posedge vga_clk)
begin
 if (hcount_ov)
  hcount <= 10'd0;
 else
  hcount <= hcount + 10'd1;
end
assign hcount_ov = (hcount == hpixel_end);

always @(posedge vga_clk)
begin
 if (hcount_ov)
 begin
  if (vcount_ov)
   vcount <= 10'd0;
  else
   vcount <= vcount + 10'd1;
 end
end


assign  vcount_ov = (vcount == vline_end);
assign  dat_act = ((hcount >= hdat_begin) && (hcount < hdat_end))
     && ((vcount >= vdat_begin) && (vcount < vdat_end));
	  
assign hsync = (hcount > hsync_end);
assign vsync = (vcount > vsync_end);

wire[9:0] xpos,ypos;

assign xpos = hcount-hdat_begin;
assign ypos = vcount-vdat_begin;

wire a_dis,b_dis,c_dis,d_dis;	

assign a_dis = ( (xpos>=120) && (xpos<=140) ) 
				&&	( (ypos>=80) && (ypos<=400) );
				
assign b_dis = ( (xpos>=500) && (xpos<=520) )
				&& ( (ypos>=80) && (ypos<=400) );

assign c_dis = ( (xpos>=140) && (xpos<=500) ) 
				&&	( (ypos>80)  && (ypos<=100) );
				
assign d_dis = ( (xpos>=140) && (xpos<=500) )
				&& ( (ypos>=380) && (ypos<=400) );

				
wire e_rdy;	

assign e_rdy = ( (xpos>=285) && (xpos<=325) )
				&&	( (ypos>=225) && (ypos<=255) );				
				
assign disp_G = dat_act ? e_rdy : 1'b0;
assign disp_B = dat_act ?  (a_dis | b_dis | c_dis | d_dis) : 1'b0;
assign disp_R = dat_act ? ~(a_dis | b_dis | c_dis | d_dis) : 1'b0;	  


endmodule
