module comb_str(Y, A, B, C, D);
	// define  output and input
	input A, B, C, D;
	output Y;
	wire u1_after, u2_after, u3_after, u4_after;
	// use structural module
	or or1(u3_after, A, D);
	not not1(u1_after, D);
	and and1(u4_after, B, C, u1_after);
	not not2(u2_after, u3_after);
	and and2(Y, u2_after, u4_after); 	 
endmodule
