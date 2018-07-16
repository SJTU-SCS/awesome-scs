module seq_detect(output reg flag, input din, clk, rst_n);
	// define output and input
	parameter IDLE=9'b0_0000_0001, A=9'b0_0000_0010, B=9'b0_0000_0100,
	C=9'b0_0000_1000, D=9'b0_0001_0000, E=9'b0_0010_0000, F=9'b0_0100_0000,
	G=9'b0_1000_0000, H=9'b1_0000_0000;
	reg [8:0] n_state;
	// always module
	always @(negedge clk)
	begin		          // if rst_n
		if (~rst_n) begin 
			n_state <= IDLE;
			flag <= 0;
		end
		else begin	
			case(n_state) // state changes by time
				IDLE: n_state <= (din) ? A : B;
				A: n_state <= (din) ? C : B;
				B: n_state <= (din) ? D : B;
				C: n_state <= (din) ? A : E;
				D: n_state <= (din) ? G : B;
				E: n_state <= (din) ? F : B;
				F: n_state <= (din) ? C : B;
				G: n_state <= (din) ? C : H;
				H: n_state <= (din) ? F : B;
				default: n_state <= IDLE;
			endcase // define flag
			flag = ((n_state==F)|(n_state==H)) ? 1 : 0;
		end
	end
	// monitor the process
	initial $monitor("it's at time %d, din=%b, rst_n=%b, flag=%b, n_state=%b",$time, din, rst_n, flag, n_state);
endmodule

module tb_seq_detect();
	// define signals
	reg clk=0, rst_n, din;
	wire flag;	  
	// create clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin
		rst_n = 1;
		#2 din = 0; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 0; #2 din = 1;
		#2 din = 1; #2 din = 0;	#2 rst_n = 0;
		#2 rst_n = 1; #2 din = 1; #2 din = 1;
		#2 din = 0; #2 din = 0; #2 din = 1;
		#2 din = 1; #2 din = 0; #2 $stop;
	end
	// example of seq_detect
	seq_detect example(flag, din, clk, rst_n);
	// monitor the process
	//initial $monitor("it's at time %d, din=%b, rst_n=%b, flag=%b", clk, din, rst_n, flag);
endmodule