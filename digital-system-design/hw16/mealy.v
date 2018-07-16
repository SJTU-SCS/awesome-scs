module mealy(output reg flag, input din, clk, rst);	 
	// define output and input
	parameter IDLE=8'b0000_0001, A=8'b0000_0010, B=8'b0000_0100,
	C=8'b0000_1000, D=8'b0001_0000, E=8'b0010_0000, F=8'b0100_0000,
	G=8'b1000_0000;
	reg [7:0] p_state,n_state;
	// always module
	always @(posedge clk or posedge rst) 
		if (rst) begin			  // if reset
			flag <= 0;
			p_state <= IDLE;
		end
		else p_state <= n_state;
	always @(*)	begin
	   case(p_state)			  // state changes
		   IDLE: n_state = (din) ? IDLE : A;
		   A: n_state = (din) ? B : A;
		   B: n_state = (din) ? IDLE : C;
		   C: n_state = (din) ? D : A;
		   D: n_state = (din) ? IDLE : E;
		   E: n_state = (din) ? F : A;
		   F: n_state = (din) ? IDLE : G;
		   G: n_state = (din) ? F : A;
		   default: n_state = IDLE;
		endcase					// flag
		flag = ((p_state==G) && (din==1)) ? 1 : 0;
	end	  
	// monitor the process
	initial $monitor("it's at time %d, din=%b, rst=%b, flag=%b, state=%b",
			$time, din, rst, flag, n_state);
endmodule