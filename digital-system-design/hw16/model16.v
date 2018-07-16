module moore(output reg flag, input din, clk, rst);
	parameter IDLE=9'b0_0000_0001, A=9'b0_0000_0010, B=9'b0_0000_0100,
	C=9'b0_0000_1000, D=9'b0_0001_0000, E=9'b0_0010_0000, F=9'b0_0100_0000,
	G=9'b0_1000_0000, H=9'b1_0000_0000;
	reg [8:0] state;
	always @(posedge clk) 
	begin
		if (rst) begin
			flag <= 0;
			state <= IDLE;
		end
		else
		   case(state)
			   IDLE: state <= (din) ? IDLE : A;
			   A: state <= (din) ? B : A;
			   B: state <= (din) ? IDLE : C;
			   C: state <= (din) ? D : A;
			   D: state <= (din) ? IDLE : E;
			   E: state <= (din) ? F : A;
			   F: state <= (din) ? IDLE : G;
			   G: state <= (din) ? H : A;
			   H: state <= (din) ? IDLE : G;
			   default: state <= IDLE;
			endcase
		flag = (state==H) ? 1 : 0;
	end	 
	initial $monitor("it's at time %d, din=%b, rst=%b, flag=%b, state=%b",
			$time, din, rst, flag, state);
endmodule

module top();
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
	moore example(flag, din, clk, rst_n);
endmodule