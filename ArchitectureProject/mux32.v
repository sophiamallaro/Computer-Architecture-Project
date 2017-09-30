// ECE:3350 SISC processor project
// 32-bit mux

`timescale 1ns/100ps

module mux32 (in_a, in_b, in_c, in_d, sel, out);

  /*
   *  32-BIT MULTIPLEXER - mux32.v
   *
   *  Inputs:
   *   - in_a (32 bits): First input to multiplexer. Selected when sel = 0.
   *   - in_b (32 bits): Second input. Selected when sel = 1.
   *   - sel: Selects which input propagates to output.
   *
   *  Outputs:
   *   - out (32 bits): Multiplexer output.
   *
   */

  input  [31:0] in_a;
  input  [31:0] in_b;
  input  [31:0] in_c;
  input  [31:0] in_d;
  input  [1:0] sel;
  output [31:0] out;

  reg   [31:0] outreg;
   
  always @ (in_a, in_b, sel)
  begin
    if (sel == 2'b00)
      outreg = in_a;
    else if(sel == 2'b01)
      outreg = in_b;
    else if(sel == 2'b10)
	outreg = in_c;
    else 
	outreg = in_d;
  end

  assign out = outreg;

endmodule
