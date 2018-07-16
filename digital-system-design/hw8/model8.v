module mux2x1(dout, sel, din);
	// define output and input
	output dout;
	input [1:0] din;
	input sel;
	// use bufif0 and bufif1 to implement
	bufif1 b2(dout, din[1], sel);
	bufif0 b1(dout, din[0], sel);  
	//initial $monitor("it's at time %d, din=%b, sel=%b dout=%d", $time, din, sel, dout);
endmodule

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

module tb_comb_str();
	// define signals
	wire y, A, B, C, D;
	reg sel=1'b0;
	reg [3:0] data;	
	// use assign to set A,B,C,D
	assign {A, B, C, D} = data;
	// change data
	initial
	begin
			 data = 4'b0000;
		# 10 data = 4'b1100;
		# 10 data = 4'b0000;
			 sel = ~sel;
		# 10 data = 4'b0011;
		$stop;
	end
	// change sel every time unit
	// example of comb_str
	comb_str example(y, sel, A, B, C, D); 
	// monitor the process
	initial $monitor("it's at time %d, ABCD=%b, sel=%d, y=%b", $time, data, sel, y);
endmodule