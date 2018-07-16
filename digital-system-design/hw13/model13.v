module shift_counter(count, clk, reset);
	// define output and input
	output reg [7:0] count=8'b0000_0001;
	input clk, reset;
	// always module
	always @(posedge clk)
	begin
		if(reset) begin
			count <= 8'b0000_0001;  
		end
		else begin
			count[7:1] <= count[6:0];
			count[0] <= count[7];
		end
	end
endmodule

module tb_shift_counter();
	// define signals
	reg clk=1'b0;
	wire [7:0] count;
	reg reset;
	// create a clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin
		reset = 1'b0;
		#26 reset = 1'b1;
		#2 reset = 1'b0; 
		#20 $stop;
	end
	// example of shift_counter
	shift_counter example(count, clk, reset);
	// monitor the process
	initial $monitor("it's at time %d, count=%b, reset=%b", $time, count, reset); 
endmodule