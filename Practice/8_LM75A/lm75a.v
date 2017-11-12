module LM75A_test(clk,rst_n,scl,sda,cs,seg);
input clk,rst_n;//50MHz;
output scl;  //I2C SCL
inout sda;   //I2C SDA
output[3:0] cs;  // 
output[7:0] seg;  // 
wire done;    // I2C 
wire[15:0] data; 
I2C_READ I2C_READ(
        .clk(clk),
 .rst_n(rst_n),
 .scl(scl),
 .sda(sda),
 .data(data)
              );
SEG_D  SEG_D(
       .clk(clk),
.rst_n(rst_n),
.cs(cs),
.seg(seg),
.data(data)
         );
endmodule