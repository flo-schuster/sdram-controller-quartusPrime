/*
	Copyright 2020 Florian Schuster
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
		http://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

module sdram_controller (
	input CLK,				// f = 166 MHz; T = 6.02409639 ns (0.00602409639 us)

	// controller
	input [31:0] in_A,
	input [31:0] in_D,
	output reg [31:0] out_D,
		// SDRAM	
	output reg [11:0] sd_A,		// Multiplexed; row address: A0-A11, column address A0-A7; A10 = H to precharge ALL banks
	output reg [1:0] sd_BS,
	inout reg [15:0] sd_DQ,
	
	output sd_CKE,
	
	output sd_CSn,
	output sd_RASn,
	output sd_CASn,
	output sd_WEn,
	output [1:0] sd_DQM
);

// PLL generates a 166 MHz clock for the SDRAM from the 12 MHz reference clock CLK12M
pll pll_inst (
	.inclk0 ( CLK12M ), 	// input	12 MHz reference clock
	.c0 ( CLK )				// output 166 MHz
);

// delay constants
localparam [15:0] INIT_PAUSE_CYCLES = 33200; // 33200 [clk_cycles] == 200 [us] / 0.00602409639 [us/clk_cycle]

// delay counter
reg [15:0]  delay_counter;

// list of commands	CS -> RAS -> CAS -> WE
localparam [3:0] CMD_NOP					= 4'b0111;
localparam [3:0] CMD_BANK_ACTIVE 		= 4'b0011;
localparam [3:0] CMD_MODE_REGISTER_SET	= 4'b0000;
localparam [3:0] CMD_PRECHARGE 			= 4'b0010;


// actual command
reg [3:0] CMD = CMD_NOP;

// assign command bits to the corresponding signals
assign sd_CSn = CMD[3];
assign sd_RASn = CMD[2];
assign sd_CASn = CMD[1];
assign sd_WEn = CMD[0];

// list of sates
localparam [2:0] STATE_INIT			= 3'b001;
localparam [2:0] STATE_NOP				= 3'b010;
localparam [2:0] STATE_PRECHARGE		= 3'b011;
localparam [2:0] STATE_MODE_REG_SET	= 3'b100;

// current state
reg [2:0] state = STATE_INIT;

always @(posedge CLK) begin
	case (state)
		
		// ------STATE INIT ------
		STATE_INIT: begin
			sd_CKE <= 1;
			sd_DQM <= 1;
			if ( INIT_PAUSE_CYCLES != 0 ) // wait 200us or equivalent INIT_PAUSE_CYCLES on init
				delay_counter <= INIT_PAUSE_CYCLES;
				state <= STATE_NOP;
			else begin
				state <= STATE_PRECHARGE;
			end
		end
		
		// ------ STATE NOP ------
		STATE_NOP: begin
			CMD <= CMD_NOP;
			delay_counter <= delay_counter - 1;
			if ( delay_counter == 0 ) // wait 200us or equivalent INIT_PAUSE_CYCLES on init
				state <= STATE_INIT;				
		end
		
		// ------ STATE PRECHARGE ------
		STATE_PRECHARGE: begin
			sd_A[10] <= 1; // A[10] = H to precharge all banks
			CMD <= CMD_PRECHARGE;
			
		end
		
		// ------ STATE MODE REGISTER SET ------
		STATE_MODE_REG_SET: begin
			
		end
		
	endcase
end

endmodule 