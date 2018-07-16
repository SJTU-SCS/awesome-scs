module sram( dout, din, addr, wr, rd, cs );
	// define output and input
	input wr, cs, rd;
	input [7:0] din;
	input [7:0] addr;
	output reg [7:0] dout;
	reg [7:0] ram [255:0];
	// always module
	always @(cs or posedge wr or rd)
	begin
		if (cs & wr)
			ram[addr] <= din;
		else;
		if(cs & ~rd)
			dout <= ram[addr];
		else ;
	end
endmodule

module tb_sram();
	// define signals
	reg [7:0] din;
	reg [7:0] addr;
	reg wr, rd, cs;
	wire [7:0] dout;
	//initial module
	initial
	begin
		cs = 1'b1;
		wr = 1'b0;
		rd = 1'b1;
		addr = 8'b0000_1111;
		din = 8'b1010_1010;
		#1 rd = 1'b0;
		#1 rd = 1'b1;
		#1 wr = 1'b1;
		#1 rd = 1'b0;
		
	end			   
	// example of sram
	sram example(dout, din, addr, wr, rd, cs);
	// monitor the process
	initial $monitor("it's at time %d, din=%b, ", $time, din, 
		"cs=%b, wr=%b, rd=%b, addr=%b, dout=%b", cs, wr, rd, addr, dout);
endmodule