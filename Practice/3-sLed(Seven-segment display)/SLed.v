module SLed(seg,dig,clk);

input clk;
output[7:0] seg;
output[3:0] dig;

reg [7:0] seg;
reg [3:0] dig;
reg [3:0] disp_dat;

reg [36:0] count;

always@(posedge clk)
begin
	count = count + 1'b1;
	dig = 4'b000;
end

always @ (count[21])
begin
disp_dat = {count[25:22]};
end

always @ (disp_dat)
begin case (disp_dat)
	4'h0 : seg = 8'hc0; //"0"
	4'h1 : seg = 8'hf9; //"1"
	4'h2 : seg = 8'ha4; //"2"
	4'h3 : seg = 8'hb0; //"3"
	4'h4 : seg = 8'h99; //"4"
	4'h5 : seg = 8'h92; //"5"
	4'h6 : seg = 8'h82; //"6"
	4'h7 : seg = 8'hf8; //"7"
	4'h8 : seg = 8'h80; //"8"
	4'h9 : seg = 8'h90; //"9"
	4'ha : seg = 8'h88; //"a"
	4'hb : seg = 8'h83; //"b"
	4'hc : seg = 8'hc6; //"c"
	4'hd : seg = 8'ha1; //"d"
	4'he : seg = 8'h86; //"e"
	4'hf : seg = 8'h8e; //"f"
endcase
end




endmodule
