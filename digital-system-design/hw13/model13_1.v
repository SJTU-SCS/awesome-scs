module shift_counter(count, clk, reset);
	// define output and input
	output reg [7:0] count=8'b0000_0001;
	input clk, reset;
	reg dir=1'b1;
	// always module
	always @(posedge clk)
	begin
		if(reset) begin	 // if reset
			count <= 8'b0000_0001; 
			dir = 1'b1;
		end
		else if(dir) begin		 // if shift
			count[7:0] <= {count[6:0], 1'b0}; 
			if (count[6])
				dir = 1'b0;
		end
		else begin
			count[7:0] <= {1'b0, count[7:1]};
			if (count[1])
				dir = 1'b1;
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
		#34 reset = 1'b1;
		#2 reset = 1'b0; 
		#20 $stop;
	end
	// example of shift_counter
	shift_counter example(count, clk, reset);
	// monitor the process
	initial $monitor("it's at time %d, count=%b, reset=%b", $time, count, reset); 
endmodule