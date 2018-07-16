module filter(sig_out, clock, reset, sig_in);
	// define output and input
	output reg sig_out;
	input clock, reset, sig_in;
	reg [3:0] data;
	wire j, k;
	//
	always @(clock)	
		if (~reset) begin
			sig_out = 0;
			data = 4'b0000;
		end
		else begin
			data[2:0] <= data[3:1];
			data[3] <= sig_in;
			case({j,k})
				2'b10: sig_out = 1;
				2'b01: sig_out = 0;
				2'b00: sig_out = sig_out;
				default: sig_out = ~sig_out;
			endcase
		end	
	//	 
	assign j = data[3] & data[2] & data[1];
	assign k = ~data[3] & ~data[2] & ~data[1];
	initial $monitor("it's at time %d, data=%b, j,k=%b, reset=%d, sig_out=%b", $time, data, {j,k}, reset, sig_out);
endmodule

module tb_filter();
	// define signals
	reg clock, reset, sig_in;
	
	always #1 clock = ~clock;
	
	initial 
	begin
		clock = 0;
		reset = 1;
		#2 sig_in = 0;
		#2 sig_in = 1;
		#2 sig_in = 0;
		#2 sig_in = 1;
		#2 sig_in = 1;
		#2 sig_in = 0;
		#2 sig_in = 0;
		#2 sig_in = 1;
		#2 sig_in = 0;
		#2 reset = 0;
		#1 reset = 1;
		#2 sig_in = 0;
		#2 sig_in = 0;
		#2 sig_in = 1;
		#1 $stop;
	end
	filter example(sig_out, clock, reset, sig_in); 
	// monitor the process
	//initial $monitor("it's at time %d, sig_in=%b, reset=%d, sig_out=%b", $time, sig_in, reset, sig_out);
endmodule