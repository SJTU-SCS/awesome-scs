module comb_dataflow(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D;
	// use assign to present the structure
	assign Y = ~(A|D) & B & C & (~D);
endmodule
	
