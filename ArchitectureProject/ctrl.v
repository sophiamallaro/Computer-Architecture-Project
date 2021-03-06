// ECE:3350 SISC computer project
// finite state machine
`timescale 1ns/100ps



module ctrl (clk, rst_f, br_sel, pc_rst, pc_write, pc_sel, rd_sel, ir_load, opcode, mm, stat, rf_we, alu_op, wb_sel, load_sel, dm_we, wr_sel);


/* TODO: Declare the ports listed above as inputs or outputs */

input clk;
input rst_f;
output br_sel; //In br file - ADDED
output pc_rst; //value of 1 here resets program counter to 0x0000 -ADDED
output pc_write; //when this goes to 1, the selected value is put on pc_out and held until it goes high again
output pc_sel; //1 for branch address, 0 in increment program counter
output rd_sel; //1 when immediate values or target values are to be used
output ir_load; //if ir_load is = 1, the IR is loaded with read_data
input [3:0] opcode;
input [3:0] mm;
input [3:0] stat;
output rf_we;
output [1:0] alu_op;
output [1:0] wb_sel;
output [1:0] load_sel; 
output dm_we; //For load instructions, this = 1. 
output wr_sel;

// states

parameter start0 = 0, start1 = 1, fetch = 2, decode = 3, execute = 4, mem = 5, writeback = 6;

// opcodes

parameter NOOP = 0, LOD = 1, STR = 2, ALU_OP = 8, BRA = 4, BRR = 5, BNE = 6, HLT=15;

// addressing modes
parameter am_imm = 8;

reg rf_we;
reg [1:0] alu_op;
reg [1:0]wb_sel;
reg br_sel; //In br file - ADDED
reg pc_rst; //value of 1 here resets program counter to 0x0000 -ADDED
reg pc_write; //when this goes to 1, the selected value is put on pc_out and held until it goes high again
reg pc_sel; //1 for branch address, 2 in increment program counter
reg rd_sel; //1 when immediate values or target values are to be used
reg ir_load; //if ir_load is = 1, the IR is loaded with read_data
reg [1:0] load_sel; //1 from instruction, 2 from alu
reg dm_we; // 1 writes data
reg wr_sel;

// state registers

reg [2:0]  present_state;
reg [2:0]  next_state;

initial begin  
	present_state <= start0;  
	next_state <= start1;  
end
 
/* TODO: Write a clock process that progresses the fsm to the next state on the
positive edge of the clock, OR resets the state to 'start0' on the negative edge
of rst_f. Notice that the computer is reset when rst_f is low, not high. */
  
//if current state is start 1
//check reset and if it is 0 keep next_state = start1
//else set next_state to fetch

always @(posedge clk or negedge rst_f) begin
	if (!rst_f) begin
		present_state <= start1; 
		next_state <= fetch;
		pc_rst <= 1;
	end else begin
		present_state <= next_state;
		pc_rst = 0;
	end
end 


always @(present_state, negedge rst_f) begin
	case(present_state)
		start0: begin
			next_state <= start1;
			end
		start1: begin
			if(!rst_f) begin
				 next_state <= start1;
				end else begin
				next_state <= fetch;
				end
			end
		fetch: begin
			next_state <= decode;
			end
		decode: begin
			next_state <= execute;
			end
		execute: begin
			next_state <= mem;
		end
		mem: begin
			next_state <= writeback;
		end
		writeback: begin
			next_state <= fetch;
		end
	endcase
end

/* TODO: Generate outputs based on the FSM states and inputs. For Parts 2 and 3, you will
       add the new control signals here. */

always @(present_state, opcode, mm) begin
case(present_state)	
	fetch: begin	
		dm_we = 0;
		ir_load = 1;	
		rf_we = 1'b0;	
		wb_sel = 2'b00;	
		alu_op = 2'b00;	
		pc_write = 0;
		wr_sel = 0;
		wb_sel = 2'b00;	
		end	
	decode: begin 	
		rf_we = 1'b0;
		wb_sel = 2'b0;
		alu_op = 2'b00;
		pc_write = 0;
		ir_load = 0; 
		if(opcode == 4'b0010) 
			rd_sel = 1'b1;
		else 
			rd_sel = 1'b0;

		if(opcode == 4'b0101 || opcode == 4'b0111) //When branch location must be determined	
			br_sel = 0; //Relative brance	
		else		
			br_sel = 1; //Absolute branch
		if((opcode == 4'b0100) || (opcode == 4'b0101) || (opcode == 4'b0110) || opcode == 4'b0111) //It is a branch instruction
			if(mm == 4'b0000)
				pc_sel = 1; //take unconditional branch
			else if((opcode == 4'b0100) || (opcode == 4'b0101)) //BRA, BRR
				if(((mm[3] == 1) && (mm[3]==stat[3])) || ((mm[2] == 1) && (mm[2]==stat[2])) || ((mm[1] == 1) && (mm[1]==stat[1])) || ((mm[0] == 1) && (mm[0]==stat[0])))
					pc_sel = 1; //take branch
				else 
					pc_sel = 0; //don't take branch
			else //BNE
				if(((mm[3] == 1) && (mm[3]==stat[3])) || ((mm[2] == 1) && (mm[2]==stat[2])) || ((mm[1] == 1) && (mm[1]==stat[1])) || ((mm[0] == 1) && (mm[0]==stat[0])))
					pc_sel = 0; //don't take branch
				else 
					pc_sel = 1; //take branch
		else 					
			pc_sel = 0; //no branch*/
		end
	execute: begin
		ir_load = 0;	
		rf_we = 1'b0;
		wb_sel = 2'b00;
		if((mm == 4'b1000) || (opcode == 4'b0010) || (opcode == 4'b0001))
			alu_op = 2'b01;	
		else	
			alu_op = 2'b00;
		pc_write = 0;
		end
	mem: begin	
		ir_load = 0;	
		pc_write = 0;
		if(opcode == 4'b0011) begin
			wr_sel = 1'b1;
			wb_sel = 2'b11;
			rf_we = 1'b1;	
		end else if (opcode == 4'b0001) begin
			wb_sel = 2'b01;
			if(mm == 4'b1001 || mm == 4'b0001) begin
				wb_sel = 2'b00;	
				wr_sel = 1'b1;
				rf_we = 1'b1;
			end else begin
				rf_we = 1'b0; 
				wr_sel = 1'b0;
			end
		end else begin
			//wr_sel = 1'b0;
			wb_sel = 2'b00;	
			rf_we = 1'b0;
		end
		if(mm == 4'b1000 || mm == 4'b1001) 
			load_sel = 2'b00;
		else if(mm == 4'b0000)
			load_sel = 2'b01;
		else 
			load_sel = 2'b10;
		end
	writeback: begin
		ir_load = 0;	
		if(opcode == 4'b0010) begin
			dm_we = 1'b1;
			wb_sel = 2'b00;
			if(mm == 4'b1001 || mm == 4'b0001) begin
				wr_sel = 1'b1;
				rf_we = 1'b1;
			end else begin
				rf_we = 1'b0;
				wr_sel = 1'b0;
			end
		end else if(opcode == 4'b0001) begin
			rf_we = 1'b1; 
			dm_we = 1'b0;
			wb_sel = 2'b01;
			wr_sel = 1'b0;
		end else if (opcode == 4'b0011) begin
			wb_sel = 2'b10;
			wr_sel = 1'b0;
		end else begin
			rf_we = 1'b1;	
			dm_we = 1'b0;
			wb_sel = 2'b00;
			wr_sel = 1'b0;
		end
		//wb_sel = 1'b00;	
		alu_op = 2'b10;	
		pc_write = 1;
		end
	default: begin	
		rf_we = 1'b0;	
		wb_sel = 2'b00;	
		alu_op = 2'b00;
		end
	endcase

end



  // Halt on HLT instruction
  


always @ (opcode) begin
	if (opcode == HLT)
 begin  
		#1 $display ("Halt."); //Delay 1 ns so $monitor will print the halt instruction
		$stop;
		end
	end
endmodule















