`include "comb_str.v" 
`include "comb_dataflow.v"
`include "comb_behavior.v"	
`include "comb_prim.v"
module testbench_comb();
	// define  signals
	reg [3:0] data;
	wire y1, y2, y3, y4;	  	 
	// set initial data
	initial data = 4'b0000;	
	// change data every time unit
	always #1 data = data + 1;
	// example of comb_str
	comb_str example(y1, data[3], data[2], data[1], data[0]); 
	comb_dataflow example(y2, data[3], data[2], data[1], data[0]);	
	comb_behavior example(y3, data[3], data[2], data[1], data[0]);	
	comb_prim example(y4, data[3], data[2], data[1], data[0]);
	//monitor the process
	initial $monitor("it's at time %d, data=%b, y1=%b, y2=%b, y3=%b, y4=%b", $time, data, y1, y2, y3, y4);
endmodule

