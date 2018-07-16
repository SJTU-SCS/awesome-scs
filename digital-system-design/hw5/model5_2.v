module comb_Y2(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D;
	// use assign to present the relationship
	assign Y = (~A) & B & (~C) & (~D) | (~A) & B & (~C) & D |
				(~A) & B & C & (~D) | (~A) & B & C & D |
				 A & (~B) & C & D | A & B & (~C) & (~D) |
				 A & B & (~C) & D;
endmodule

module tb_comb_Y2();
	// define signals
	wire y;
	reg [3:0] data;
	// use initial to set data
	initial data = 4'b0000;
	// use always to change data
	always
	begin 
		#1 data = data + 1;	  
		// if the circle ends then stop
		if (data==4'b0000) $stop;
		else ;
	end	  
	//example of comb_Y1
	comb_Y2 example(y, data[3], data[2], data[1], data[0]);
	// monitor the process
	initial $monitor("it's at time %d, data=%b, y=%b", $time, data, y);			 
endmodule