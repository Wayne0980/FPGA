`timescale 1ns/1ns

module and_gate_tb;

	reg a,b,d,e;
	wire c,f;

	and_gate u1(
	.a(a),
	.b(b),
	.c(c),
	.d(d),
	.e(e),
	.f(f));

	initial begin
		a=0;b=0;
		d=0;e=0;
	
		forever begin
		
			#20 a=0;b=0;  d=0;e=0;
			#20 a=1;b=0;  d=1;e=0;
			#20 a=0;b=1;  d=0;e=1;
			#20 a=1;b=1;  d=1;e=1;
		end
	end
	
	
	
endmodule