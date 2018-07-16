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

module tb_ALU();
	// define signals
	reg a, b, c_in;
	reg [2:0] oper;
	wire c_out, sum;
	// always module
	initial begin
		{a, b, c_in} = 3'b111;
		#1 oper = 3'b000;
		#1 oper = 3'b001;
		#1 oper = 3'b010;
		#1 oper = 3'b011;
		#1 oper = 3'b100;
		#1 oper = 3'b101;
		#1 oper = 3'b110;
		#1 oper = 3'b111;
		#1 {a, b, c_in} = 3'b101; 
		#1 oper = 3'b000;
		#1 oper = 3'b001;
		#1 oper = 3'b010;
		#1 oper = 3'b011;
		#1 oper = 3'b100;
		#1 oper = 3'b101;
		#1 oper = 3'b110;
		#1 oper = 3'b111;
		#1 $stop;
	end
	// example of ALU
	ALU example(c_out, sum, oper, a, b, c_in );
	// monitor the process
	initial $monitor("it's at time %d, oper=%b, a,b,c_in=%b, sum=%b, c_out=%b", $time, oper, {a,b,c_in}, sum, c_out);
endmodule