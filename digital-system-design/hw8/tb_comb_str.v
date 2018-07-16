`include "comb_str.v"
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
	