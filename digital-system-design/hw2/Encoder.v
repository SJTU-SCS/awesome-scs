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
		
		