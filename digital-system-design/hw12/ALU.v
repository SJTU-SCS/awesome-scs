module ALU(c_out, sum, oper, a, b, c_in);
	// define output and input
	output reg c_out, sum;
	input [2:0] oper;
	input a, b, c_in;
	// always operate module
	always @(*)
	case(oper)
		3'b000: {c_out, sum} = a + b + c_in;
		3'b001: {c_out, sum} = a + ~b + c_in;
		3'b010: {c_out, sum} = b + ~a + c_in;
		3'b011: {c_out, sum} = {1'b0, a | b};
		3'b100: {c_out, sum} = {1'b0, a & b};
		3'b101: {c_out, sum} = {1'b0, ~a & b};
		3'b110: {c_out, sum} = {1'b0, a ^ b}; 
		3'b111: {c_out, sum} = {1'b0, a ~^ b};
		default: {c_out, sum} = a + b + c_in;
	endcase
endmodule

