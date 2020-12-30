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

// PLL generates a 166 MHz clock for the SDRAM from the 12 MHz reference clock CLK12M
pll pll_inst (
	.inclk0 ( CLK12M ), 	// input	12 MHz reference clock
	.c0 ( CLK )				// output 166 MHz
);


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
	input sd_RASn,
	input sd_CASn,
	input sd_WEn,
	input [1:0] sd_DQM
);
// constants
localparam integer INIT_PAUSE_CYCLES = 33200; // [clk_cycles] == 200 [us] / 0.00602409639 [us/clk_cycle]

// list of commands
localparam [3:0] CMD_NOP					= 4'b0111;
localparam [3:0] CMD_BANK_ACTIVE 		= 4'b0011;
localparam [3:0] CMD_MODE_REGISTER_SET	= 4'b0000;
localparam [3:0] CMD_PRECHARGE 			= 4'b0010;


// actual command
assign reg [3:0] CMD = CMD_NOP;

// assign command bits to the corresponding signals
assign sd_CSn = CMD[3];
assign sd_RASn = CMD[2];
assign sd_CASn = CMD[1];
assign sd_WEn = CMD[0];

// list of sates
localparam [2:0] STATE_INIT = 3'b001;

reg [2:0] state;

assign sd_CKE = 1;
assign sd_DQM = 1;

always @(posedge CLK) begin
	case (state):
	
		STATE_INIT: begin
			if ( INIT_PAUSE_CYCLES != 0 ) // wait 200us or quivalent INIT_PAUSE_CYCLES on init
				INIT_PAUSE_CYCLES <= INIT_PAUSE_CYCLES - 1;
			else begin
				CMD <= CMD_PRECHARGE;
				sd_A[10] <= 1; // A[10] = H to precharge all banks
				sd_DQM <= 0;
			end
		end
		
	endcase
end

endmodule 