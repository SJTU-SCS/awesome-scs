`include "mux2x1.v"
module comb_str(y, sel, A, B, C, D);
	// define output and input
	output y;
	input sel, A, B, C, D;
	wire in0, in1;
	// example of internal structure model
	nand #(3) nand1(in0, A, B);
	nand #(4) nand2(in1, C, D);
	mux2x1 example(y, sel, {in1, in0});
endmodule
	