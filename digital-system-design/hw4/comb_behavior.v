module comb_behavior(Y, A, B, C, D);
	// define output and input
	output reg Y;
	input A, B, C, D;
	// use always to present the relationship
	always @(A or B or C or D)
		Y <= ~(A|D) & B & C & (~D);
endmodule 


