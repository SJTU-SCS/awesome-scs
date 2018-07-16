
module mealy(output reg flag, input din, clk, rst);
	parameter IDLE=8'b0000_0001, A=8'b0000_0010, B=8'b0000_0100,
	C=8'b0000_1000, D=8'b0001_0000, E=8'b0010_0000, F=8'b0100_0000,
	G=8'b1000_0000;
	reg [7:0] p_state,n_state;
	always @(posedge clk or posedge rst) 
		if (rst) begin
			flag <= 0;
			p_state <= IDLE;
		end
		else p_state <= n_state;
	always @(*)	begin
	   case(p_state)
		   IDLE: n_state = (din) ? IDLE : A;
		   A: n_state = (din) ? B : A;
		   B: n_state = (din) ? IDLE : C;
		   C: n_state = (din) ? D : A;
		   D: n_state = (din) ? IDLE : E;
		   E: n_state = (din) ? F : A;
		   F: n_state = (din) ? IDLE : G;
		   G: n_state = (din) ? F : A;
		   default: n_state = IDLE;
		endcase
		flag = ((p_state==G) && (din==1)) ? 1 : 0;
	end	 
	initial $monitor("it's at time %d, din=%b, rst=%b, flag=%b, state=%b",
			$time, din, rst, flag, n_state);
endmodule

module top2();
	// define signals
	reg clk=1, rst_n, din;
	wire flag;	  
	// create clock
	always #1 clk = ~clk;
	// initial module
	initial
	begin // create some signals
		rst_n = 0; din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 1; #2 din = 0; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 0; #2 din = 1;	#2 rst_n = 1;
		#2 rst_n = 0; #2 din = 0; #2 din = 1;
		#2 din = 0; #2 din = 1; #2 din = 0;
		#2 din = 1; #2 din = 0; #2 din = 1;
		#2 din = 1; #2 $stop;
	end
	// example of moore
	mealy example(flag, din, clk, rst_n);
endmodule