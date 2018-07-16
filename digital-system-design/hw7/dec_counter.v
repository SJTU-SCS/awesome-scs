module dec_counter(count, clk, reset);
	// define output and input
	output reg [3:0] count;
	input [31:0] clk;
	input reset;
	// initial count
	initial count = 4'b0000;
	// count process
	always @(clk)
	begin
		if (reset)// if reset
			count <= 0;
		else	  // if not reset
		begin 
			count <= count + 1;	 
			// if count=10 then change to 0 in to next clk
			if (count == 4'b1010)  
				count <= 4'b0000;  
		end
	end
endmodule 

