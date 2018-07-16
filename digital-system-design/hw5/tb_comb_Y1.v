`include "comb_Y1.v"
module tb_comb_Y1();
	// define signals
	wire y;
	reg [2:0] data;
	// use initial to set data
	initial data = 3'b000;
	// use always to change data
	always
	begin 
		#1 data = data + 1;	  
		// if the circle ends then stop
		if (data==3'b000) $stop;
		else ;
	end	  
	//example of comb_Y1
	comb_Y1 example(y, data[2], data[1], data[0]);
	// monitor the process
	initial $monitor("it's at time %d, data=%b, y=%b", $time, data, y);			 
endmodule 
