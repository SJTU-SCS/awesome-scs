module sram( dout, din, addr, wr, rd, cs );
	// define output and input
	input wr, cs, rd;
	input [7:0] din;
	input [7:0] addr;
	output reg [7:0] dout;
	reg [7:0] ram [255:0];
	// always module
	always @(posedge cs or posedge wr or negedge rd)
	begin
		if (cs & wr) // din -> ram
			ram[addr] <= din;
		else;
		if(cs & ~rd) // ram -> dout
			dout <= ram[addr];
		else ;
	end
endmodule 

