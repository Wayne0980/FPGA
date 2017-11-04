`timescale 1ns / 1ns

module VGA_Char(	
				clk,
				hsync,vsync,vga_r,vga_g,vga_b,
				seg,dig	
			);
			
reg  clk_25m;
input  clk;	
output hsync;	
output vsync;	
output vga_r;
output vga_g;
output vga_b;

//--------------------------------------------------
	
reg[9:0] x_cnt;		
reg[9:0] y_cnt;		

output[7:0] seg;
output[3:0] dig;

reg [7:0] seg;
reg [3:0] dig;

reg [36:0] count;

parameter hsync_end   = 10'd95,
   hdat_begin  = 10'd143,
   hdat_end  = 10'd783,
   hpixel_end  = 10'd799,
   vsync_end  = 10'd1,
   vdat_begin  = 10'd34,
   vdat_end  = 10'd514,
   vline_end  = 10'd524;
	
always @ (posedge clk)
begin
clk_25m = ~clk_25m;   // 1/2 clk
end


always@(posedge clk_25m)
begin
	count = count +1;
	if(count==1000)
	begin
		seg = 8'hc7;
		dig = 4'b1110; //"0"
	end
	if(count==2000)
   begin 
	   seg = 8'hf9;
		dig = 4'b1101; //"0"
	end
	if(count==3000)
	begin
      seg = 8'h8c;
		dig = 4'b1011; //"0"
	end
	if(count==4000)
	begin
		seg = 8'h92;
		dig = 4'b0111; //"0"
	end
	if(count==4001)
		count = 0;
end


always @ (posedge clk_25m)
	
	if(x_cnt == hpixel_end) x_cnt <= 10'd0;
	else x_cnt <= x_cnt+1'b1;

always @ (posedge clk_25m)
	
	if(y_cnt == vline_end) y_cnt <= 10'd0;
	else if(x_cnt == hpixel_end) y_cnt <= y_cnt+1'b1;


reg hsync_r,vsync_r;	
 
always @ (posedge clk_25m)
								
	if(x_cnt == 10'd0) hsync_r <= 1'b0;	
	else if(x_cnt == hsync_end) hsync_r <= 1'b1;

always @ (posedge clk_25m)
								  
	if(y_cnt == 10'd0) vsync_r <= 1'b0;	
	else if(y_cnt == 10'd2) vsync_r <= 1'b1;

assign hsync = hsync_r;
assign vsync = vsync_r;


reg valid_yr;	
always @ (posedge clk_25m)
	
	if(y_cnt == vdat_begin) valid_yr <= 1'b1;
	else if(y_cnt == hdat_end) valid_yr <= 1'b0;	

wire valid_y = valid_yr;

reg valid_r;	
always @ (posedge clk_25m)
	
	if((x_cnt == hdat_begin) && valid_y) valid_r <= 1'b1;
	else if((x_cnt == hdat_end) && valid_y) valid_r <= 1'b0;
	
wire valid = valid_r;		

wire[9:0] y_dis;	

//assign x_dis = x_cnt - 10'd142;
assign y_dis = y_cnt - vdat_begin;
//--------------------------------------------------

parameter 			
char_line0 = 192'h000000000000000000000000 ,
char_line1 = 192'h000000000000000000000000 ,
char_line2 = 192'h000000000000000000000000 ,
char_line3 = 192'h000000000000000000000000 ,
char_line4 = 192'h000000000000000000000000 ,
char_line5 = 192'h000000000000000000000000 ,
char_line6 = 192'h00fe10fffe0007ffe0ffe000,
char_line7 = 192'h0383f07fffc001ff807f8000,
char_line8 = 192'h0700f00e01f0003c001f0000,
char_line9 = 192'h0600780e0078003c000e0000,
char_line10= 192'h0c00380e001c0018000e0000,
char_line11= 192'h0C00380e000e0018000e0000,
char_line12= 192'h0C00180e000e0018000e0000,
char_line13= 192'h1C00180e000f0018000e0000,
char_line14= 192'h1C00080e00070018000e0000,
char_line15= 192'h1e00080e00070018000e0000,
char_line16= 192'h0f00000e00070018000e0000,
char_line17= 192'h0f80000e00070018000e0000,
char_line18= 192'h07c0000e000f0018000e0000,
char_line19= 192'h07e0000e000e0018000e0000,
char_line20= 192'h00FC000e001e0018000e0000,
char_line21= 192'h003F800e001c0018000e0000,
char_line22= 192'h000FC00e00780018000e0000,
char_line23= 192'h0007E00e01f00018000e0000,
char_line24= 192'h0001F00fffc00018000e0000,
char_line25= 192'h0000F80e78000018000e0000,
char_line26= 192'h0000780e00000018000e0000,
char_line27= 192'h00003C0e00000018000e0000,
char_line28= 192'h00003C0e00000018000e0000,
char_line29= 192'h20001C0e00000018000e0000,
char_line30= 192'h30001C0e00000018000e0000,
char_line31= 192'h30001C0e00000018000e0000,
char_line32= 192'h18001C0e00000018000e0000,
char_line33= 192'h18001C0e00000018000e0000,
char_line34= 192'h1C00380e00000018000e0000,
char_line35= 192'h1E00380e00000018000e0000,
char_line36= 192'h1F00700e00000018000e0000,
char_line37= 192'h1F81E00f0000003c000e0006,
char_line38= 192'h187F800f0000003c000e000e,
char_line39= 192'h0000003fc00001ff801e003e,
char_line40= 192'h000000fff00007ffe03ffffc,
char_line41= 192'h000000000000000000000000,
char_line42= 192'h000000000000000000000000,
char_line43= 192'h000000000000000000000000,
char_line44= 192'h000000000000000000000000,
char_line45= 192'h000000000000000000000000,
char_line46= 192'h000000000000000000000000,
char_line47= 192'h000000000000000000000000;

reg[7:0] char_bit;	

always @(posedge clk_25m)
	
	if(x_cnt == 10'd442) char_bit <= 9'd96;
	else if(x_cnt > 10'd442 && x_cnt < 10'd540) char_bit <= char_bit-1'b1;	
	
reg[7:0] vga_rgb;	

always @ (posedge clk_25m)
	if(!valid) vga_rgb <= 8'd0;
	else if(x_cnt > 10'd442 && x_cnt < 10'd540) begin
		case(y_dis)
			10'd231: if(char_line0[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd232: if(char_line1[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd233: if(char_line2[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd234: if(char_line3[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd235: if(char_line4[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd236: if(char_line5[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd237: if(char_line6[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd238: if(char_line7[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd239: if(char_line8[char_bit]) vga_rgb <= 8'b111_111_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd240: if(char_line9[char_bit]) vga_rgb <= 8'b111_111_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ
			10'd241: if(char_line10[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ		 		 		 		 		 
			10'd242: if(char_line11[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ			 
			10'd243: if(char_line12[char_bit]) vga_rgb <= 8'b111_111_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ	
			10'd244: if(char_line13[char_bit]) vga_rgb <= 8'b111_111_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ	
			10'd245: if(char_line14[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ	
			10'd246: if(char_line15[char_bit]) vga_rgb <= 8'b011_000_11;	//��ɫ
					 else vga_rgb <= 8'b111_11111;	//��ɫ			 		 


			10'd247: if(char_line16[char_bit]) vga_rgb <= 8'b111_111_11;	
					 else vga_rgb <= 8'b111_11111;	
			10'd248: if(char_line17[char_bit]) vga_rgb <= 8'b111_111_11;	
					 else vga_rgb <= 8'b111_11111;	

			10'd249: if(char_line18[char_bit]) vga_rgb <= 8'b011_000_11;	
					else vga_rgb <= 8'b111_11111;	
			10'd250: if(char_line19[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd251: if(char_line20[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd252: if(char_line21[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd253: if(char_line22[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd254: if(char_line23[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd255: if(char_line24[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd256: if(char_line25[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd257: if(char_line26[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd258: if(char_line27[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd259: if(char_line28[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd260: if(char_line29[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd261: if(char_line30[char_bit]) vga_rgb <= 8'b011_000_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd262: if(char_line31[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd263: if(char_line32[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd264: if(char_line33[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd265: if(char_line34[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd266: if(char_line35[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd267: if(char_line36[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	


							 
			10'd268: if(char_line37[char_bit]) vga_rgb <= 8'b111_111_11;	
							 else vga_rgb <= 8'b111_11111;	
			10'd269: if(char_line38[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd270: if(char_line39[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd271: if(char_line40[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd272: if(char_line41[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd273: if(char_line42[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd274: if(char_line43[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd275: if(char_line44[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd276: if(char_line45[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
				 
							 
			10'd277: if(char_line46[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
			10'd278: if(char_line47[char_bit]) vga_rgb <= 8'b011_000_00;	
							 else vga_rgb <= 8'b111_11111;	
				 
				
					 
		default: vga_rgb <= 8'h00;
		endcase
	end
	else vga_rgb <= 8'h00;

	//r,g,b����Һ������ɫ��ʾ
assign vga_r = vga_rgb[7];
assign vga_g = vga_rgb[4];
assign vga_b = vga_rgb[1];

endmodule
