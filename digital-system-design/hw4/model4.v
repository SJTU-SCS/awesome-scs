module comb_str(Y, A, B, C, D);
	// define of output and input
	input A, B, C, D;
	output Y;
	wire u1_after, u2_after, u3_after, u4_after;
	// use structural module
	or or1(u3_after, A, D);
	not not1(u1_after, D);
	and and1(u4_after, B, C, u1_after);
	not not2(u2_after, u3_after);
	and and2(Y, u2_after, u4_after); 	 
endmodule

module comb_dataflow(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D;
	// use assign to present the structure
	assign Y = ~(A|D) & B & C & (~D);
endmodule

module comb_behavior(Y, A, B, C, D);
	// define output and input
	output reg Y;
	input A, B, C, D;
	// use always to present the relationship
	always @(A or B or C or D)
		Y = ~(A|D) & B & C & (~D);
endmodule

primitive comb_prim(Y, A, B, C, D);
	// define output and input
	output Y;
	input A, B, C, D; 
	
	table
		// primitive table
		0 0 0 0 : 0; 
		0 0 0 1 : 0;
		0 0 1 0 : 0;
		0 0 1 1 : 0;
		0 1 0 0 : 0;
		0 1 0 1 : 0;
		0 1 1 0 : 1;
		0 1 1 1 : 0;
		1 0 0 0 : 0; 
		1 0 0 1 : 0;
		1 0 1 0 : 0;
		1 0 1 1 : 0;
		1 1 0 0 : 0;
		1 1 0 1 : 0;
		1 1 1 0 : 0;
		1 1 1 1 : 0;   
	endtable
endprimitive

module testbench_comb();
	// define of output and input
	reg [3:0] data;
	wire y1, y2, y3, y4;	  	 
	// set initial data
	initial data = 4'b0000;	
	// change data every time unit
	always #1 data = data + 1;
	// example of comb_str
	comb_str example1(y1, data[3], data[2], data[1], data[0]); 
	comb_dataflow example2(y2, data[3], data[2], data[1], data[0]);	
	comb_behavior example3(y3, data[3], data[2], data[1], data[0]);	
	comb_prim example4(y4, data[3], data[2], data[1], data[0]);
	//monitor the process
	initial $monitor("it's at time %d, data=%b, y1=%b, y2=%b, y3=%b, y4=%b", $time, data, y1, y2, y3, y4);
	
endmodule