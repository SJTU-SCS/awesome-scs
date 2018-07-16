module Encoder8x3(code, data);
	//define an output
	output reg [7:0] data;
	input [2:0] code;
	//use always module to change data value
	always @(*) 
	case(code)//when code changes, data changes accordingly
		3'b000: data = 8'b0000_0001;
		3'b001: data = 8'b0000_0010;
		3'b010: data = 8'b0000_0100;
		3'b011: data = 8'b0000_1000;
		3'b100: data = 8'b0001_0000;
		3'b101: data = 8'b0010_0000;
		3'b110: data = 8'b0100_0000;
		3'b111: data = 8'b1000_0000;  
		default: data = 8'b0000_0001;//default data	 
	endcase
endmodule

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