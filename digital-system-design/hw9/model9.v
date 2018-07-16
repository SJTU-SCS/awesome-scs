module LFSR( output reg [1:26] q, // 26 bit data output.
			 input clk, // Clock input.
			 input rst_n, // Synchronous reset input.
			 input load, // Synchronous load input.
			 input [1:26] din // 26 bit parallel data input.
			);
	always @(clk) 
	begin
		if ( ~rst_n )
			q <= 0;
		else begin
			if (load)
				q <= (|din) ? din : 26'b1;
			else begin
				if ( q == 0 )
					q <= 1;
				else begin
					q[9:26] <= q[8:25];
					q[8] <= q[7] ^ q[26];
					q[7] <= q[6] ^ q[26];
					q[3:6] <= q[2:5];
					q[2] <= q[1] ^ q[26];
					q[1] <= q[26];
				end
			end
		end
	end
endmodule

module tb_LFSR();
	// define signals
	wire [1:26] q;
	reg clk, rst_n, load;
	wire [1:26] din=26'b1;
	// create clock
	always #1 clk = ~clk;
	initial 
	begin
		clk = 0;
		rst_n = 1;
		load = 0;
		#15 rst_n = 0;
		#1  rst_n = 1;
		#50 load = 1;
		#1  load = 0;	  
		#10 $stop;
	end
	// example of LFSR
	LFSR example(q, clk, rst_n, load, din);	
	// monitor the process
	initial $monitor("it's at time %d, q=%b, rst_n=%d, load=%b", $time, q, rst_n, load);
endmodule