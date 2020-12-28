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
	input CLK12M,
	input CKE,
	
	output reg [11:0] A,		// Multiplexed; row address: A0-A11, column address A0-A7; A10 = H to precharge ALL banks
	output reg [1:0] BS,
	inout reg [15:0] DQ,
	
	input CSn,
	input RASn,
	input CASn,
	input WEn
	input [1:0] DQM,
);

localparam [3:0] CMD_NOP 			= 4'b0000;
localparam [3:0] CMD_BANK_ACTIVE = 4'b0011;
localparam [3:0] CMD_PRECHARGE 	= 4'b0010;

// TODO: add commands from datasheet

localparam [3:0] CMD_NOP 			= 4'b1111;





endmodule 