module mux2x1(dout, sel, din);
	// define output and input
	output dout;
	input [1:0] din;
	input sel;
	// use bufif0 and bufif1 to implement
	bufif1 b2(dout, din[1], sel);
	bufif0 b1(dout, din[0], sel);
endmodule