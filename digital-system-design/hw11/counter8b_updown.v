module counter8b_updown(count, clk, reset, dir);
	// define output and input
	output reg [7:0] count;
	input clk, reset, dir;
	// always module
	always @(posedge clk or posedge reset)
	begin
		if (reset) // if reset
			count <= 8'b0000_0000;
		else begin
			if (dir==1'b0) // if dir = 1
				count <= count - 1;
			else if (dir==1'b1) // if dir = 0
				count <= count + 1; 
			else ;
		end
	end
endmodule
		