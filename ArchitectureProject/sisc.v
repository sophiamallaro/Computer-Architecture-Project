// ECE:3350 SISC processor project
// main SISC module, part 1

`timescale 1ns/100ps  

module sisc (clk, rst_f);

input clk, rst_f;
wire [31:0] ir;

// declare all internal wires here
wire[31:0] rsa;
wire[31:0] rsb;
wire[15:0] imm;
wire[1:0] alu_op;
wire[31:0] alu_result;
wire[3:0] stat;
wire stat_en;
wire rst_f;
wire[3:0] opcode;
wire[3:0] mm;
wire rf_we;
wire[1:0] wb_sel;
wire[31:0]  write_data;
wire[3:0] read_rega;
wire[3:0] read_regb;
//wire[3:0] read_regb;
wire[3:0] write_reg;
//wire[31:0] in_a = 32'b00000000000000000000000000000000;
wire[3:0] in_b;
wire sel_mux4 = 1'b0;
wire[3:0] stat_out; 
wire br_sel;
wire pc_rst;
wire pc_write;
wire pc_sel;
wire rd_sel;
wire[15:0] pc_inc;
wire[15:0] br_addr;
wire[15:0] read_addr;
wire[31:0] read_data;
wire ir_load;
wire[15:0] pc_out;
wire[15:0] out;
wire[31:0] write_data_mem = 32'b00000000000000000000000000000000 | ir[15:0];
wire[3:0] wr_out;
wire wr_sel;
wire[31:0] mem_out;
wire[1:0] load_sel;

// component instantiation goes here
//Part One
alu i1(clk, rsa, rsb, ir[15:0], alu_op, alu_result, stat, stat_en);
ctrl i2(clk, rst_f, br_sel, pc_rst, pc_write, pc_sel, rd_sel, ir_load, ir[31:28], ir[27:24], stat, rf_we, alu_op, wb_sel, load_sel, dm_we, wr_sel);
mux32 i3(alu_result, mem_out, rsa, rsb, wb_sel, write_data);
rf i4(clk, ir[19:16], read_regb, write_reg, write_data, rf_we, rsa, rsb);
mux4 i5(ir[15:12], ir[23:20], rd_sel, read_regb);
statreg i6(clk, stat, stat_en, stat_out);
//Part Two
br i7(pc_inc, ir[15:0], br_sel, br_addr);
im i8(pc_out, read_data);
ir i9(clk, ir_load, read_data, ir);
pc i11(clk, br_addr, pc_sel, pc_write, pc_rst, pc_out, pc_inc);
//Part Three
dm i12(out, out, rsb, dm_we, mem_out);
mux16 i13(alu_result, ir[15:0], rsa, load_sel, out);
writeRegMux i14(ir[23:20], ir[19:16], wr_sel, write_reg);



initial begin
$monitor("t=%3d, R1=%32b, R2=%32b, R3=%32b, IR=%32b, BR_SEL=%b, PC_SEL=%b, PC_WRITE=%b, PC=%16b", $time, i4.ram_array[1], i4.ram_array[2], i4.ram_array[3], ir, br_sel, pc_sel, pc_write, pc_out);
//$monitor("ir = %32b" ,ir);
//PC_WRITE, 

end

endmodule
