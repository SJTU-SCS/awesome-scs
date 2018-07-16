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
			dir <= 1'b1;
		end
		else if(dir) begin		 // if shift left
			count[7:0] <= {count[6:0], 1'b0}; 
			if (count[6])
				dir = 1'b0;
		end
		else begin				 // if shift right
			count[7:0] <= {1'b0, count[7:1]};
			if (count[1])
				dir = 1'b1;
		end
	end
endmodule  
