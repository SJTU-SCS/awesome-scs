
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 	   Shanghai Jiao Tong University
// Engineer: 	   Huanfei	
// 
// Create Date:    13:26:56 02/20/2012 
// Design Name: 
// Module Name:    LCD_Driver 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module LCD_Driver( output SF_CE0,			// 4 位 LCD 数据信号与 StrataFlash 存储器共享数据线 SF_D<11:8>. 
											// 当 SF_CE0 = High 时, 禁用 StrataFlash 存储器, 
											// 此时 FPGA 完全 read/write 访问 LCD.
				   output LCD_RW,			// Read/Write Control
											// 0: WRITE, LCD accepts SF_D
											// 1: READ, LCD presents SF_D
					
				   output LCD_RS,			// Register Select
											// 0: Instruction register during write operations. 
											//    Busy Flash during read operations
											// 1: Data for read or write operations
					
				   output [3:0] SF_D,		// Four-bit SF_D interface, Data bit DB7 ~ DB4, 
											// Shared with StrataFlash pins SF_D<11:8>
					
				   output LCD_E,			// Read/Write Enable Pulse,
											// 0: Disabled, 1: Read/Write operation enabled											
					
				   input clock,				// 连接 On-Board 50 MHz Oscillator CLK_50MHz (C9)
				   input reset				// 使用按键 BTN EAST(H13)做为复位键
					
				  );
	
	///////////////////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////
	// 定义 LCD 初始化和显示配置状态变量

	parameter 	INIT_IDLE		= 4'h1,
				WAITING_READY 	= 4'h2,
	
				WR_ENABLE_1		= 4'h3,
				WAITING_1		= 4'h4,
				WR_ENABLE_2		= 4'h5,
				WAITING_2		= 4'h6,
				
				WR_ENABLE_3		= 4'h7,
				WAITING_3		= 4'h8,
				WR_ENABLE_4		= 4'h9,
				WAITING_4		= 4'hA,
				
				INIT_DONE		= 4'hB;

	// 保存 LCD 初始化状态变量: 位宽 3 bits
	reg [3:0] init_state;
	
	// 时序控制计数器
	// The 15 ms interval is 750,000 clock cycles at 50 MHz.
	// 750,000 (dec) = 1011_0111_0001_1011_0000(bin) 需要 20 bits
	reg [19:0] cnt_init;
	
	// 初始化状态标志
	// 0: 初始化未完成
	// 1: 初始化已完成
	reg init_done;
	
	reg [7:0] count1;
	reg [7:0] count2;
	reg [7:0] count3;
	reg [7:0] count4;
	reg [7:0] count5;
	
	
	always @(posedge clock)
	begin
		if (count1==8'h9) begin
			count1 = 0;
			count2 = count2 + 1;
		end
		else
			count1 = count1 + 1;
		if (count2==8'h10) begin
			count2 = 0;
			count3 = count3 + 1;
		end 
		if (count3==8'h6) begin
			count3 = 0;
			count4 = count4 + 1;
		end
		if (count4==8'h10) begin
			count4 = 0;
			count5 = count5 + 1;
		end
		if (count5==8'h6) begin
			count5 = 0;
		end
	end
	
	
	
	
	

				
	parameter	DISPLAY_INIT	= 4'h1,
	
				FUNCTION_SET	= 4'h2,
				ENTRY_MODE_SET	= 4'h3,
				DISPLAY_ON_OFF	= 4'h4,
				DISPLAY_CLEAR	= 4'h5,
				CLEAR_EXECUTION	= 4'h6,
				IDLE_2SEC 		= 4'h7,

				SET_DD_RAM_ADDR	= 4'h8,
				LCD_LINE_1		= 4'h9,
				SET_NEWLINE		= 4'hA,
				LCD_LINE_2		= 4'hB,
				DISPLAY_DONE    = 4'hC;
				
				
	
	// 保存 LCD 显示配置状态变量: 位宽 3 bits
	reg [3:0] ctrl_state;
		
	// 时序控制计数器
	// Clear the display and return the cursor to the home position, the top-left corner.
	// Execution Time at least 1.64 ms (82,000 clock cycles)
	// 82,000 (dec) = 1_0100_0000_0101_0000 (bin) 需要 17 bits
	reg [16:0] cnt_delay;	

	// 控制初始化标志
	// 1: 启动传输过程
	// 0: 停止传输过程
	reg init_exec;
	
	// 复位后, 等待 2 sec, 运行在 50 MHz 时钟频率
	// 等待 100,000,000(dec) = 101_1111_0101_1110_0001_0000_0000 (bin) (27 bits) 时钟周期
	reg [26:0] cnt_2sec;

	// 控制传输标志
	// 1: 启动涔?	// 0: 停止传输过程
	reg tx_ctrl;
	
	// 传输序列状态
	parameter 	TX_IDLE		= 8'H01,
				UPPER_SETUP	= 8'H02,
				UPPER_HOLD	= 8'H04,
				ONE_US		= 8'H08,
				LOWER_SETUP	= 8'H10,
				LOWER_HOLD	= 8'H20,
				FORTY_US	= 8'H40;


	// 保存传输序列状态: 位宽 7 bits
	reg [6:0] tx_state;
			
	// 传输控制时序计数器
	// The time between successive commands is 40us, which corresponds to 2000 clock cycles
	// 2000 (dec ) = 111_1101_0000 (bin) 需要 11 bits
	reg [10:0] cnt_tx;
		
	// Register Select
	// 0: Instruction register during write operations. Busy Flash during read operations
	// 1: Data for read or write operations
	reg select;
	
	// The upper nibble is transferred first, followed by the lower nibble.
	reg [3:0] nibble; 
	reg [3:0] DB_init; 	// 用于初始化
	
	// Read/Write Enable Pulse, 0: Disabled, 1: Read/Write operation enabled
	reg enable;
	reg en_init;        // 用于初始化
	
	reg mux;			// 标志初始化过程，传输命令/数据
						// 0: 初始化
						// 1: 传输命令/数据
	
	// 向 LCD 传输的数据字节: 位宽 8 bits
	reg [7:0] tx_byte;
	
	// 保存第 1 行显示输出的字符数据
	reg [7:0] tx_Line1;
	
	// 保存第 2 行显示输出的字符数据
	reg [7:0] tx_Line2;
	
	// 显示字符计数器
	reg [3:0] cnt_1 = 4'b0;	// For Line 1
	reg [3:0] cnt_2 = 4'b0;	// For Line 2
	
	///////////////////////////////////////////////////////////////////////////////////////////		
	// 禁用 Intel strataflash 存储器, 将 Read/Write 控制设置为 Write, 即: LCD 接收数据
	assign SF_CE0 	= 1'b1; 	// Disable intel strataflash
	
	assign LCD_RW 	= 1'b0;		// Write only 
	
	assign LCD_RS 	= select;
	
	assign SF_D 	= ( mux ) ? nibble : DB_init;	
	
	assign LCD_E 	= ( mux ) ? enable : en_init;
	
	always @(*)
	begin
		case ( ctrl_state )
			DISPLAY_INIT:		mux = 1'b0;	// power on initialization sequence
			FUNCTION_SET,
			ENTRY_MODE_SET,
			DISPLAY_ON_OFF,
			DISPLAY_CLEAR,
			IDLE_2SEC,
			CLEAR_EXECUTION,
			SET_DD_RAM_ADDR,
			LCD_LINE_1,
			SET_NEWLINE,
			LCD_LINE_2:			mux = 1'b1;
			default:			mux = 1'b0;
		endcase
	end
	///////////////////////////////////////////////////////////////////////////////////////////
	
	
	// The following "always" statements simplify the process of adding and removing states.			
	//
	// refer to datasheet for an explanation of these values

	// 向 LCD 传输的命令字节: 位宽 8 bits
	// In Verilog-2001, you can initialize registers when you declare them.
	// Now Xilinx XST has supported to initialize registers
	always @( * ) begin
		case ( ctrl_state )
			FUNCTION_SET:		begin
									tx_byte = 8'b0010_1000;
									select = 1'b0;
								end
			ENTRY_MODE_SET:		begin
									tx_byte = 8'b0000_0110;
									select = 1'b0;
								end
			DISPLAY_ON_OFF:		begin
									tx_byte = 8'b0000_1100;
									select = 1'b0;
								end
			DISPLAY_CLEAR:		begin
									tx_byte = 8'b0000_0001;
									select = 1'b0;
								end
			SET_DD_RAM_ADDR:	begin
									tx_byte = 8'b1000_0000;
									select = 1'b0;
								end
			///////////////////////////////////////////////////
			LCD_LINE_1:			begin
									tx_byte = tx_Line1;
									select = 1'b1;
								end
			SET_NEWLINE:		begin
									tx_byte = 8'b1100_0000;
									select = 1'b0;
								end			
			///////////////////////////////////////////////////
			LCD_LINE_2:			begin
									tx_byte = tx_Line2;
									select = 1'b1;
								end
			
			default: 			begin
									tx_byte = 8'b0;
									select = 1'b0;
								end
		endcase
	end
	
	always @(*)
	begin
		case ( cnt_1 )
			0:		tx_Line1 = 8'b0101_0011;		// CHAR_S
			1:		tx_Line1 = 8'b0111_0100;		// CHAR_t
			2:		tx_Line1 = 8'b0110_1111;		// CHAR_o
			3:		tx_Line1	= 8'b0111_0000;		// CHAR_p
			4:		tx_Line1	= 8'b0111_0111;		// CHAR_w
			5:		tx_Line1	= 8'b0110_0001;		// CHAR_a
			6:		tx_Line1	= 8'b0111_0100;		// CHAR_t
			7:		tx_Line1	= 8'b0110_0011;		// CHAR_c
			8:		tx_Line1	= 8'b0110_1000;		// CHAR_h
			default:tx_Line1 	= 8'b0;				// NONE
		endcase
	end
		
	always @(*)
	begin
		case ( cnt_2 )
			0:		tx_Line2 = 8'b0101_0100;		// CHAR_T
			1:		tx_Line2 = 8'b0110_1001;		// CHAR_i
			2:		tx_Line2 = 8'b0110_1101;		// CHAR_m
			3:		tx_Line2 = 8'b0110_0101;		// CHAR_e
			4:		tx_Line2 = 8'b0011_1010;		// CHAR_:
			5:		tx_Line2 = 8'b0011_0000+count5;		// CHAR_0
			6:		tx_Line2 = 8'b0011_0000+count4;		// CHAR_0
			7:		tx_Line2 = 8'b0011_1010;		// CHAR_:
			8:		tx_Line2 = 8'b0011_0000+count3;		// CHAR_0
			9:		tx_Line2 = 8'b0011_0000+count2;		// CHAR_0
			10:	tx_Line2 = 8'b0011_1010;		// CHAR_:
			11:	tx_Line2 = 8'b0111_0010+count1;		// CHAR_0
			default:tx_Line2 	= 8'b0;				// NONE
		endcase
	end
	
/*		上电后 LCD 初始化过程
		Power-On Initialization
		
		The initialization sequence first establishes that the FPGA application 
		wishes to use the four-bit SF_D interface to the LCD as follows:
	
		(0) Wait 15 ms or longer, although the display is generally ready when the FPGA finishes configuration. 
		    The 15 ms interval is 750,000 clock cycles at 50 MHz.
		  
		(1) Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.

		(2) Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
		
		(3) Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.
		
		(4) Wait 100 μs or longer, which is 5,000 clock cycles at 50 MHz.

		(5) Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.

		(6) Wait 40 μs or longer, which is 2,000 clock cycles at 50 MHz.
		
		(7) Write SF_D<11:8> = 0x2, pulse LCD_E High for 12 clock cycles.

		(8) Wait 40 μs or longer, which is 2,000 clock cycles at 50 MHz.
*/	

	// Initializing the Display
	always @( posedge clock )
	begin
		if( reset ) begin
			init_state <= INIT_IDLE;
			
			DB_init <= 4'b0;
			en_init <= 0;
			
			cnt_init <= 0;
			
			init_done <= 0;
		end

		else begin
			case ( init_state )
				// power on initialization sequence
				INIT_IDLE:			begin
										en_init <= 0;
										
										if ( init_exec  )
											init_state <= WAITING_READY;
										else
											init_state <= INIT_IDLE;
									end
				
				WAITING_READY:		begin	// (0 )等待 15 ms 或更长, LCD 准备显示
										en_init <= 0;
										
										if ( cnt_init <= 750000 ) begin
											DB_init <= 4'h0;

											cnt_init <= cnt_init + 1;
											
											init_state <= WAITING_READY;
										end
										else begin
											cnt_init <= 0;
											
											init_state <= WR_ENABLE_1;
										end
									end
										
				WR_ENABLE_1:		begin
										DB_init <= 4'h3;			// Write SF_D<11:8> = 0x3
										
										en_init <= 1'b1;			// Pulse LCD_E High for 12 clock cycles.
										
										if ( cnt_init < 12 ) begin	 
											cnt_init <= cnt_init + 1;
											
											init_state <= WR_ENABLE_1;
										end
										else begin
											cnt_init <= 0;
											
											init_state <= WAITING_1;
										end
									end

				WAITING_1:			begin	// Wait 4.1 ms or longer, which is 205,000 clock cycles at 50 MHz.
										en_init <= 1'b0;			
										
										if ( cnt_init <= 205000 ) begin	 
											
											cnt_init <= cnt_init + 1;
											
											init_state <= WAITING_1;
									end
									else begin
											cnt_init <= 0;
											
											init_state <= WR_ENABLE_2;
										end
									end
				WR_ENABLE_2:		begin
										DB_init <= 4'h3;			// Write SF_D<11:8> = 0x3
										en_init <= 1'b1;			// Pulse LCD_E High for 12 clock cycles.
										
										if ( cnt_init < 12 ) begin	 
																						
											cnt_init <= cnt_init + 1;
											
											init_state <= WR_ENABLE_2;
									end
									else begin
											cnt_init <= 0;
											
											init_state <= WAITING_2;
										end
									end
									// Wait 100 μs or longer, which is 5,000 clock cycles at 50 MHz.
				WAITING_2:			begin
										en_init <= 1'b0;
											
										if ( cnt_init <= 5000 ) begin	 
											
											cnt_init <= cnt_init + 1;
											
											init_state <= WAITING_2;
										end
										else begin
											cnt_init <= 0;
											
											init_state <= WR_ENABLE_3;
										end
									end
					
				WR_ENABLE_3:		begin	//  Write SF_D<11:8> = 0x3, pulse LCD_E High for 12 clock cycles.
										DB_init <= 4'h3;			// Write SF_D<11:8> = 0x3
										en_init <= 1'b1;			// Pulse LCD_E High for 12 clock cycles.
										
										if ( cnt_init < 12 ) begin	 
																						
											cnt_init <= cnt_init + 1;
											
											init_state <= WR_ENABLE_3;
									end
									else begin
											cnt_init <= 0;
											
											init_state <= WAITING_3;
										end
									end

				WAITING_3:			begin	//  Wait 40 us or longer, which is 2,000 clock cycles at 50 MHz.
										en_init <= 1'b0;	
										
										if ( cnt_init <= 2000 ) begin	 
											
											cnt_init <= cnt_init + 1;
											
											init_state <= WAITING_3;
									end
									else begin
											cnt_init <= 0;
											
											init_state <= WR_ENABLE_4;
										end
									end

				WR_ENABLE_4:		begin	//  Write SF_D<11:8> = 0x2, pulse LCD_E High for 12 clock cycles.
										DB_init <= 4'h2;			// Write SF_D<11:8> = 0x3
										en_init <= 1'b1;			// Pulse LCD_E High for 12 clock cycles.
										
										if ( cnt_init < 12 ) begin	 
																						
											cnt_init <= cnt_init + 1;
											
											init_state <= WR_ENABLE_4;
									end
									else begin
											cnt_init <= 0;
											
											init_state <= WAITING_4;
										end
									end

				WAITING_4:			begin	//  Wait 40 us or longer, which is 2,000 clock cycles at 50 MHz.
										en_init <= 1'b0;										
										
										if ( cnt_init <= 2000 ) begin
											cnt_init <= cnt_init + 1;
											
											init_state <= WAITING_4;
										end
										else begin
											DB_init <= 4'h0;		// Write SF_D<11:8> = 0x0
											cnt_init <= 0;
											
											cnt_init <= 0;
											
											init_done <= 1'b1;
											init_state <= INIT_DONE;
										end
									end

				INIT_DONE:			begin
										init_state <= INIT_DONE;
										
										DB_init <= 4'h0;
										en_init <= 1'b0;
										
										cnt_init <= 0;
										
										init_done <= 1'b1;
									end
				default:			begin
										init_state <= INIT_IDLE;
			
										DB_init <= 4'b0;
										en_init <= 0;
			
										cnt_init <= 0;
			
										init_done <= 0;
									end
			endcase
		end
	end
	
	
	always @( * )
	begin
		case ( ctrl_state )
			DISPLAY_INIT:		tx_ctrl = 1'b0;
			FUNCTION_SET,
			ENTRY_MODE_SET,
			DISPLAY_ON_OFF,
			DISPLAY_CLEAR:		tx_ctrl = 1'b1;
			CLEAR_EXECUTION:	tx_ctrl = 1'b0;
			SET_DD_RAM_ADDR,
			LCD_LINE_1,
			SET_NEWLINE,
			LCD_LINE_2:			tx_ctrl = 1'b1;
			DISPLAY_DONE:		tx_ctrl = 1'b0;
			default:			tx_ctrl = 1'b0;
		endcase
	end		
	
	// Main state machine
	always @( posedge clock )
	begin
		if( reset ) begin
			ctrl_state <= DISPLAY_INIT;
			
			cnt_delay <= 0;
			cnt_1 <= 0;
			cnt_2 <= 0;
			
			cnt_2sec <= 0;
		end

		else begin
			case ( ctrl_state )
				// power on initialization sequence
				DISPLAY_INIT:		begin	// (0 )等待 15 ms 或更长, LCD 准备显示
										init_exec <= 1;
										
										if ( init_done ) begin
											ctrl_state <= FUNCTION_SET;
											cnt_1 <= 0;
											cnt_2 <= 0;
										end
										else begin
											ctrl_state <= DISPLAY_INIT;
										end
									end

				FUNCTION_SET:		begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= FUNCTION_SET;
										end
										else begin
											ctrl_state <= ENTRY_MODE_SET;
										end		
									end
				
				ENTRY_MODE_SET:		begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= ENTRY_MODE_SET;
										end
										else begin
											ctrl_state <= DISPLAY_ON_OFF;
										end
									end
				
				DISPLAY_ON_OFF:		begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= DISPLAY_ON_OFF;
										end
										else begin
											ctrl_state <= DISPLAY_CLEAR;
										end
									end
									
				DISPLAY_CLEAR:		begin 
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= DISPLAY_CLEAR;
										end
										else begin
											ctrl_state <= CLEAR_EXECUTION;
											
											cnt_delay <= 0;
										end
									end
				
				CLEAR_EXECUTION:	begin
										// The delay after a Clear Display command is 1.64ms, 
										// which corresponds to 82000 clock cycles. 
										if ( cnt_delay <= 82000 ) begin
											ctrl_state <= CLEAR_EXECUTION;
											
											cnt_delay <= cnt_delay + 1;
										end
										else begin
											ctrl_state <= IDLE_2SEC;
											cnt_delay <= 0;
											
											cnt_2sec <= 0;
										end
									end
				
				IDLE_2SEC:			begin // 清屏后, 等待 2 sec, 观察复位
										if ( cnt_2sec < 27'd100000000 ) begin  
											ctrl_state <= IDLE_2SEC;
											cnt_2sec <= cnt_2sec + 1;
										end
										else begin
											ctrl_state <= SET_DD_RAM_ADDR;
											
											cnt_delay <= 0;
										end										
									end

				SET_DD_RAM_ADDR:	begin   
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= SET_DD_RAM_ADDR;
										end
										else begin
											ctrl_state <= LCD_LINE_1;
											cnt_1 <= 0;
										end
									end

				LCD_LINE_1:			begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= LCD_LINE_1;
										end
										else if ( cnt_1 < 8 ) begin
												ctrl_state <= LCD_LINE_1;
												
												cnt_1 <= cnt_1 + 1;
											end
											else begin	
												ctrl_state <= SET_NEWLINE;
												
												cnt_1 <= 0;
											end
									end
													
				SET_NEWLINE:		begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= SET_NEWLINE;
										end
										else begin
											ctrl_state <= LCD_LINE_2;
											
											cnt_2 <= 0;
										end
									end	
									
				LCD_LINE_2:			begin
										// Wait 40 us or longer
										if ( cnt_tx <= 2000 ) begin
											ctrl_state <= LCD_LINE_2;
										end
										else if ( cnt_2 < 11 ) begin
												ctrl_state <= LCD_LINE_2;
												
												cnt_2 <= cnt_2 + 1;
											end
											else begin	
												ctrl_state <= DISPLAY_DONE;
												
												cnt_2 <= 0;
											end
									end
				
				DISPLAY_DONE:		begin
										ctrl_state <= DISPLAY_DONE;
									end
				default:			begin
										ctrl_state <= DISPLAY_INIT;
			
										cnt_delay <= 0;
										cnt_1 <= 0;
										cnt_2 <= 0;
										
										cnt_2sec <= 0;
									end
			endcase
		end
	end	
/*
	Four-Bit Data Interface

	The board uses a 4-bit SF_D interface to the character LCD.
	The SF_D values on SF_D<11:8>, and the register select (LCD_RS) and the read/write (LCD_RW) 
	control signals must be set up and stable at least 40 ns before the enable LCD_E goes High. 
	
	The enable signal must remain High for 230 ns or longer-the equivalent of 12 or more clock cycles at 50 MHz.

	In many applications, the LCD_RW signal can be tied Low permanently 
	because the FPGA generally has no reason to read information from the display.

	Transferring 8-Bit Data over the 4-Bit Interface

	After initializing the display and establishing communication, 
	all commands and SF_D transfers to the character display are via 8 bits, 
	transferred using two sequential 4-bit operations. 
	Each 8-bit transfer must be decomposed into two 4-bit transfers, spaced apart by at least 1 μs. 
	
	The upper nibble is transferred first, followed by the lower nibble. 
	An 8-bit write operation must be spaced least 40 μs before the next communication. 
	This delay must be increased to 1.64 ms following a Clear Display command.

	Note that the period of the 50MHz onboard clock is 20ns. 

	The time between corresponding nibbles is 1us, which is equivalent to 50 clock cycles. 

	The time between successive commands is 40us, which corresponds to 2000 clock cycles. 

	The delay after a Clear Display command is 1.64ms, which corresponds to 82000 clock cycles. 

	Setup time ( time for the outputs to stabilize ) is 40ns, which is 2 clock cycles, 
	the hold time ( time to assert the LCD_E pin ) is 230ns, which translates to roughly 12 clock cycles, 
	and the fall time ( time to allow the outputs to stabilize) is 10ns, which translates to roughly 1 clock cycle.
*/
	// specified by datasheet, transmit process
		// specified by datasheet, transmit process
	always @( posedge clock )
	begin
		if ( reset ) begin
			enable <= 1'b0;
			nibble <= 4'b0;

			tx_state <= TX_IDLE;
			cnt_tx <= 0;
		end
		else  begin
			case ( tx_state )
				TX_IDLE:			begin
										enable <= 1'b0;
										nibble <= 4'b0;
										cnt_tx <= 0;

										if ( tx_ctrl ) begin
											tx_state <= UPPER_SETUP;
										end
										else begin
											tx_state <= TX_IDLE;
										end
									end
				// Setup time ( time for the outputs to stabilize ) is 40ns, which is 2 clock cycles
				UPPER_SETUP:		begin	
										nibble <= tx_byte[7:4];
										
										if ( cnt_tx < 2 ) begin
											enable <= 1'b0;
											
											tx_state <= UPPER_SETUP;
										
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											enable <= 1'b1;
										
											tx_state <= UPPER_HOLD;
											cnt_tx <= 0;
										end
									end
				// Hold time ( time to assert the LCD_E pin ) is 230ns, which translates to roughly 12 clock cycles
				UPPER_HOLD:			begin
										nibble <= tx_byte[7:4];
										
										if ( cnt_tx < 12 ) begin
											enable <= 1'b1;
											tx_state <= UPPER_HOLD;
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											enable <= 1'b0;
											tx_state <= ONE_US;
											cnt_tx <= 0;
										end
									end
				// Each 8-bit transfer must be decomposed into two 4-bit transfers, spaced apart by at least 1 μs.
				// The upper nibble is transferred first, followed by the lower nibble. 
				// The time between corresponding nibbles is 1us, which is equivalent to 50 clock cycles.
				ONE_US:				begin
										enable <= 1'b0;
									
										if ( cnt_tx <= 50 ) begin
											tx_state <= ONE_US;
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											tx_state <= LOWER_SETUP;
											cnt_tx <= 0;
										end
									end
				// Setup time ( time for the outputs to stabilize ) is 40ns, which is 2 clock cycles						
				LOWER_SETUP:		begin	
										nibble <= tx_byte[3:0];
										
										if ( cnt_tx < 2 ) begin
											enable <= 1'b0;
										
											tx_state <= LOWER_SETUP;
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											enable <= 1'b1;
											
											tx_state <= LOWER_HOLD;
											cnt_tx <= 0;
										end
									end
								
				// Hold time ( time to assert the LCD_E pin ) is 230ns, which translates to roughly 12 clock cycles
				LOWER_HOLD:			begin
										nibble <= tx_byte[3:0];
										
										if ( cnt_tx < 12 ) begin
											enable <= 1'b1;
											tx_state <= LOWER_HOLD;
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											enable <= 1'b0;
											tx_state <= FORTY_US;
											cnt_tx <= 0;
										end
									end

				// The time between successive commands is 40us, which corresponds to 2000 clock cycles. 
				FORTY_US:			begin
										enable <= 1'b0;
								
										if ( cnt_tx <= 2000 ) begin
											tx_state <= FORTY_US;
											cnt_tx <= cnt_tx + 1;
										end
										else begin
											tx_state <= TX_IDLE;
											cnt_tx <= 0;
										end
									end
				default:			begin
											enable <= 1'b0;
											nibble <= 4'b0;
											
											tx_state <= TX_IDLE;
											cnt_tx <= 0;
									end
			endcase
		end
	end
endmodule
