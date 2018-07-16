`include "ALU.v"
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

