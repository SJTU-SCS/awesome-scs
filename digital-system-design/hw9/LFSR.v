module LFSR( output reg [1:26] q, // 26 bit data output.
			 input clk, // Clock input.
			 input rst_n, // Synchronous reset input.
			 input load, // Synchronous load input.
			 input [1:26] din // 26 bit parallel data input.
			);
	always @(clk) 
	begin
		if ( ~rst_n )// if reset
			q <= 0;
		else begin
			if (load)// if load
				q <= (|din) ? din : 26'b1;
			else begin
				if ( q == 0 )
					q <= 1;
				else begin// change the q
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
