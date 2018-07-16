module comb_Y2(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D;
	// use assign to present the relationship
	assign Y = (~A) & B & (~C) & (~D) | (~A) & B & (~C) & D |
				(~A) & B & C & (~D) | (~A) & B & C & D |
				 A & (~B) & C & D | A & B & (~C) & (~D) |
				 A & B & (~C) & D;
endmodule	
