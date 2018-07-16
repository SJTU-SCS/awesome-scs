`include "mux2x1.v"
module mux4x1(dout, sel, din);
	// define output and input
	output dout;
	input [3:0] din;
	input [2:0] sel;  
	wire dout1, dout2;
	// sel[0] control din[3:2] 
	mux2x1 example1(dout1, sel[0], din[3:2]);  
	// sel[0] control din[1:0]
	mux2x1 example2(dout2, sel[0], din[1:0]);
	// sel[1] control dout1,dout2
	mux2x1 example3(dout, sel[1], {dout1, dout2}); 
endmodule
	
	
	
	