module and_gate(a,b,c,d,e,f);

	input a,b,d,e;
	output c,f;
	assign c = a & b;
	assign f = d | e;
endmodule