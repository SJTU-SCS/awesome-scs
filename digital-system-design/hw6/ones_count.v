module ones_count(count, dat_in);
	// define output and input
	output [3:0] count;
	input [7:0] dat_in;
	// use assign to calculate count  
	assign count = dat_in[0] + dat_in[1] + dat_in[2] + 
				   dat_in[3] + dat_in[4] + dat_in[5] +
				   dat_in[6] + dat_in[7];
endmodule
