module dec_counter(count, clk, reset);
	// define output and input
	output reg [3:0] count;
	input [7:0] clk;
	input reset;
	// initial count
	initial count = 4'b0000;
	// count process
	always @(clk)
	begin
		if (reset)
			count = 0;
		else
		begin 
			count = count + 1;	 
			// if count=10 then change to 0 in to next clk
			if (count == 4'b1010)  
				count = 4'b0000;  
		end
	end
endmodule

module tb_dec_counter();
	// define signals
	reg [7:0] clk;
	wire [3:0] count;
	reg reset;
	// initially set clk and reset
	initial 
	begin 
		clk = 0;
		reset  =1'b0;	  		  
	end
	// create a clk and change reset every 7 time units
	always 
	begin
		#1 clk = clk + 1;  
		if (clk == 8'b0000_0000)
			$stop;
		else ;	  
	end
	always
	begin
		#18 reset = 1; 
		#1 reset = 0;	 
	end
	// example of dec_counter
	dec_counter example(count, clk, reset);
	// monitor the process
	initial $monitor("it's at time %d, clk=%d, count=%d, reset=%b", $time, clk, count, reset);	  
endmodule