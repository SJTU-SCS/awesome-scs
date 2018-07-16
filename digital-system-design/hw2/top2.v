`include "Encoder.v"
module tb_Encoder8x3();
	//define code and data
	wire [7:0] data;
	reg [2:0] code;
	// give some code value
	initial
	begin 
		   code = 3'b000;
		#1 code = 3'b001;
		#1 code = 3'b010;
		#1 code = 3'b011;
		#1 code = 3'b100;
		#1 code = 3'b101;
		#1 code = 3'b110;
		#1 code = 3'b111;
		#1 code = 3'b000;
	end
	// example of module Encoder8x3
	Encoder8x3 example(code, data);
	//monitor the process
	initial $monitor("it's at time %d, data=%b", $time, data);
endmodule

