`include "mux4x1.v"
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
	
