module comb_Y1(Y, A, B, C);
	// define output and input
	output Y;
	input A, B, C;
	// use assign to present the relationship
	assign Y = (~A) & (~B) & C | (~A) & B & (~C) |
				A & (~B) & (~C) | A & (~B) & C;
endmodule
