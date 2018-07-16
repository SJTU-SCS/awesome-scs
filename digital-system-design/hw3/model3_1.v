module mux2x1(dout, sel, din);
	// define output and input
	output dout;
	input [1:0] din;
	input sel;
	// use bufif0 and bufif1 to implement
	bufif1 b2(dout, din[1], sel);
	bufif0 b1(dout, din[0], sel);
endmodule

module tb_mux2x1();
	// define signals
	reg [1:0] din;
	reg sel;
	wire dout;		
	// initial din and sel 
	initial
	begin	
		din = 2'b10;
		sel = 0;
	end		  	 
    // change sel periodicly   
	always #1 sel = ~sel; 	
	// example of mux2x1 module
	mux2x1 example(dout, sel, din);  
	//monitor the process
	initial $monitor("it's at time %d, dout=%d", $time, dout);
endmodule