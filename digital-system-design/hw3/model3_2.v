module mux2x1(dout, sel, din);
	// define output and input
	output dout;
	input [1:0] din;
	input sel;
	// use bufif0 and bufif1 to implement
	bufif1 b2(dout, din[1], sel);
	bufif0 b1(dout, din[0], sel);
endmodule

module mux4x1(dout, sel, din);
	// define output and input
	output dout;
	input [3:0] din;
	input [2:0] sel;  
	wire dout1, dout2;
	// example of mux2x1 
	mux2x1 example1(dout1, sel[0], din[3:2]);
	mux2x1 example2(dout2, sel[0], din[1:0]);  
	mux2x1 example3(dout, sel[1], {dout1, dout2}); 
endmodule
	
module tb_mux4x1();
	// define signals
	reg [3:0] din;
	reg [1:0] sel;
	wire dout;		
	// initial din and sel 
	initial
	begin	
		din = 4'b0000;
		sel = 2'b00;
	end		  	 
    // change sel periodicly   
	always #1 sel = sel + 1; 
	always #1 din = din + 1;
	// example of mux2x1 module
	mux4x1 example(dout, sel, din);  
	//monitor the process
	initial $monitor("it's at time %d, din=%b, sel=%b dout=%d", $time, din, sel, dout);
endmodule