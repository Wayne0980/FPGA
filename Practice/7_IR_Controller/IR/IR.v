
 

module IR(clk,rst_n,IR,led_cs,led_db);

  input   clk;
  input   rst_n;
  input   IR;
  output [3:0] led_cs;
  output [7:0] led_db;
  reg [7:0] led_trans_db[4:0];
  reg [3:0] led_cs;
  reg [7:0] led_db;
 
  reg [7:0] led1,led2,led3,led4;
  reg [15:0] irda_data;    // save irda data,than send to 7 segment led
  reg [31:0] get_data;     // use for saving 32 bytes irda data
  reg [5:0]  data_cnt;     // 32 bytes irda data counter
  reg [2:0]  cs,ns;
  reg error_flag;          // 32 bytes 

  //----------------------------------------------------------------------------
  reg irda_reg0;       
  reg irda_reg1;      
  reg irda_reg2;       
  wire irda_neg_pulse;
  wire irda_pos_pulse; 
  wire irda_chang;     
  
  reg[15:0] cnt_scan;
   
  always @ (posedge clk) 
    if(!rst_n)
      begin
        irda_reg0 <= 1'b0;
        irda_reg1 <= 1'b0;
        irda_reg2 <= 1'b0;
      end
    else
      begin
        //led_cs <= 4'b0000; 
        irda_reg0 <= IR;
        irda_reg1 <= irda_reg0;
        irda_reg2 <= irda_reg1;
      end
     
  assign irda_chang = irda_neg_pulse | irda_pos_pulse;  
  assign irda_neg_pulse = irda_reg2 & (~irda_reg1);  // detect ---\______
  assign irda_pos_pulse = (~irda_reg2) & irda_reg1;  // detect ____/-----


  reg [10:0] counter; 
  reg [8:0]  counter2; 
  wire check_9ms;  // check leader 9ms time
  wire check_4ms;  // check leader 4.5ms time
  wire low;        // check  data="0" time
  wire high;       // check  data="1" time
 
 
  always @ (posedge clk)
    if (!rst_n)
      counter <= 11'd0;
    else if (irda_chang)  
      counter <= 11'd0;
    else if (counter == 11'd1750)
      counter <= 11'd0;
    else
      counter <= counter + 1'b1;
		
always @ (posedge clk)
begin 
	if(counter==300)
	begin
		led_db = led_trans_db[0];
		led_cs <= 4'b1110; 
	end
	if(counter==600)
   begin 
	  led_db = led_trans_db[1];
	  led_cs <= 4'b1101; 
	end
	if(counter==900)
	begin
      led_db = led_trans_db[2];
		led_cs <= 4'b1011; 
	end
	if(counter==1200)
	begin
		led_db = led_trans_db[3];
		led_cs <= 4'b0111; 
	end
	if(counter==1500)
	begin
		led_db = led_trans_db[3];
		led_cs <= 4'b1111; 
	end
end 
  //---------------------------------------------------------------------------- 
  always @ (posedge clk)
    if (!rst_n)
      counter2 <= 9'd0;
    else if (irda_chang)  
      counter2 <= 9'd0;
    else if (counter == 11'd1750)
      counter2 <= counter2 +1'b1;
  

  assign check_9ms = ((217 < counter2) & (counter2 < 297)); 
 
  assign check_4ms = ((88 < counter2) & (counter2 < 168));  // 4.5ms = 128(counter2) * 0.02us(50MHz) * 1750(counter1) 
  assign low  = ((6 < counter2) & (counter2 < 26));         // 16 (35us*16 = 560us)
  assign high = ((38 < counter2) & (counter2 < 58));        // 48 (35us*48 = 1680us)

  //----------------------------------------------------------------------------
  // generate statemachine 
    parameter IDLE       = 3'b000, 
              LEADER_9   = 3'b001, // 9ms
              LEADER_4   = 3'b010, // 4ms
              DATA_STATE = 3'b100; 
 
  always @ (posedge clk)
    if (!rst_n)
      cs <= IDLE;
    else
      cs <= ns; 
     
  always @ ( * )
    case (cs)
      IDLE:
        if (~irda_reg1)
          ns = LEADER_9;
        else
          ns = IDLE;
   
      LEADER_9:
        if (irda_pos_pulse)   // leader 9ms check
          begin
            if (check_9ms)
              ns = LEADER_4;
            else
              ns = IDLE;
          end
        else  
          ns =LEADER_9;
   
      LEADER_4:
        if (irda_neg_pulse)  // leader 4.5ms check
          begin
            if (check_4ms)
              ns = DATA_STATE;
            else
              ns = IDLE;
          end
        else
          ns = LEADER_4;
   
      DATA_STATE:
        if ((data_cnt == 6'd32) & irda_reg2 & irda_reg1)
          ns = IDLE;
        else if (error_flag)
          ns = IDLE;
        else
          ns = DATA_STATE;
      default:
        ns = IDLE;
    endcase

 
  always @ (posedge clk)
    if (!rst_n)
      begin
        data_cnt <= 6'd0;
        get_data <= 32'd0;
        error_flag <= 1'b0;
      end
  
    else if (cs == IDLE)
      begin
        data_cnt <= 6'd0;
        get_data <= 32'd0;
        error_flag <= 1'b0;
      end
  
    else if (cs == DATA_STATE)
      begin
        if (irda_pos_pulse)  // low 0.56ms check
          begin
            if (!low)  //error
              error_flag <= 1'b1;
          end
        else if (irda_neg_pulse)  //check 0.56ms/1.68ms data 0/1
          begin
            if (low)
              get_data[0] <= 1'b0;
            else if (high)
              get_data[0] <= 1'b1;
            else
              error_flag <= 1'b1;
             
            get_data[31:1] <= get_data[30:0];
            data_cnt <= data_cnt + 1'b1;
          end
      end

  always @ (posedge clk)
    if (!rst_n)
      irda_data <= 16'd0;
    else if ((data_cnt ==6'd32) & irda_reg1)
  begin
   led1 <= get_data[7:0]; 
   led2 <= get_data[15:8]; 
   led3 <= get_data[23:16];
   led4 <= get_data[31:24];
  end

always@(led1) 
begin
	case(led1)
	
	                    
        8'b01101000: 
			led_trans_db[0]=8'b1100_0000;

		8'b00110000: 
			led_trans_db[0]=8'b1111_1001;  //ʾ1

		8'b00011000: 
			led_trans_db[0]=8'b1010_0100;  //ʾ2

		8'b01111010: 
			led_trans_db[0]=8'b1011_0000;  //ʾ3

		8'b00010000: 
			led_trans_db[0]=8'b1001_1001;  //ʾ4

		8'b00111000: 
			led_trans_db[0]=8'b1001_0010;  //ʾ5

		8'b01011010: 
			led_trans_db[0]=8'b1000_0010;  //ʾ6

		8'b01000010: 
			led_trans_db[0]=8'b1111_1000;  //ʾ7

		8'b01001010: 
			led_trans_db[0]=8'b1000_0000;  //ʾ8

		8'b01010010: 
			led_trans_db[0]=8'b1001_0000;  //ʾ9
			
	
	   default: led_trans_db[0]=8'b1000_1110;

	 endcase
end
always@(led2) 
begin
	case(led2)
	
	                    
        8'b01101000: 
			led_trans_db[1]=8'b1100_0000;  //ʾ0

		8'b00110000: 
			led_trans_db[1]=8'b1111_1001;  //ʾ1

		8'b00011000: 
			led_trans_db[1]=8'b1010_0100;  //ʾ2

		8'b01111010: 
			led_trans_db[1]=8'b1011_0000;  //ʾ3

		8'b00010000: 
			led_trans_db[1]=8'b1001_1001;  //ʾ4

		8'b00111000: 
			led_trans_db[1]=8'b1001_0010;  //ʾ5

		8'b01011010: 
			led_trans_db[1]=8'b1000_0010;  //ʾ6

		8'b01000010: 
			led_trans_db[1]=8'b1111_1000;  //ʾ7

		8'b01001010: 
			led_trans_db[1]=8'b1000_0000;  //ʾ8

		8'b01010010: 
			led_trans_db[1]=8'b1001_0000;  //ʾ9
			
	
	   default: led_trans_db[1]=8'b1000_1110;

	 endcase
end
always@(led3) 
begin
	case(led3)
	
	                    
        8'b01101000: 
			led_trans_db[2]=8'b1100_0000;  //ʾ0

		8'b00110000: 
			led_trans_db[2]=8'b1111_1001;  //ʾ1

		8'b00011000: 
			led_trans_db[2]=8'b1010_0100;  //ʾ2

		8'b01111010: 
			led_trans_db[2]=8'b1011_0000;  //ʾ3

		8'b00010000: 
			led_trans_db[2]=8'b1001_1001;  //ʾ4

		8'b00111000: 
			led_trans_db[2]=8'b1001_0010;  //ʾ5

		8'b01011010: 
			led_trans_db[2]=8'b1000_0010;  //ʾ6

		8'b01000010: 
			led_trans_db[2]=8'b1111_1000;  //ʾ7

		8'b01001010: 
			led_trans_db[2]=8'b1000_0000;  //ʾ8

		8'b01010010: 
			led_trans_db[2]=8'b1001_0000;  //ʾ9
			
	
	   default: led_trans_db[2]=8'b1000_1110;

	 endcase
end
always@(led4) 
begin
	case(led4)
	
	                    
        8'b01101000: 
			led_trans_db[3]=8'b1100_0000;  //ʾ0

		8'b00110000: 
			led_trans_db[3]=8'b1111_1001;  //ʾ1

		8'b00011000: 
			led_trans_db[3]=8'b1010_0100;  //ʾ2

		8'b01111010: 
			led_trans_db[3]=8'b1011_0000;  //ʾ3

		8'b00010000: 
			led_trans_db[3]=8'b1001_1001;  //ʾ4

		8'b00111000: 
			led_trans_db[3]=8'b1001_0010;  //ʾ5

		8'b01011010: 
			led_trans_db[3]=8'b1000_0010;  //ʾ6

		8'b01000010: 
			led_trans_db[3]=8'b1111_1000;  //ʾ7

		8'b01001010: 
			led_trans_db[3]=8'b1000_0000;  //ʾ8

		8'b01010010: 
			led_trans_db[3]=8'b1001_0000;  //ʾ9
			
	
	   default: led_trans_db[3]=8'b1000_1110;

	 endcase
end
endmodule 


