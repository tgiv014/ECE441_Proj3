/*================================================
Thomas Gorham
ECE 441 Spring 2017
Project 2 - bcd_ctr
Description: This module implements a 3-digit
bcd counter with async reset and enable inputs.
It is intended to be controlled by a state machine
that manages inputs from the lfsr and pushbuttons
================================================*/
`timescale 100 ns / 1 ns


module bcd_ctr(clk, en, ar, dig1, dig2, dig3);
  /*======================================
  Parameters
  ======================================*/

  /*======================================
  Input/Output Declaration
  ======================================*/
  input clk, ar, en;
  output reg  [3:0]  dig1, dig2, dig3;

  /*======================================
  Internal wires/registers
  ======================================*/
  wire dig1_carry, dig2_carry, dig3_carry;

  /*======================================
  Asynchronous Logic
  ======================================*/
  assign dig1_carry = (dig1 == 4'd9); // Flag to indicate when to inc dig2
  assign dig2_carry = dig1_carry&(dig2 == 4'd9); // Indicates when to inc dig3
  assign dig3_carry = dig2_carry&(dig3 == 4'd9); // Indicates when timer should freeze

  /*======================================
  Synchronous Logic
  ======================================*/
  always @ (posedge clk or negedge ar)
  begin
    if(~ar) // If ar is brought low, (or is low on a clk posedge)
    begin
      // Reset the current count
      dig1 <= 4'd0;
      dig2 <= 4'd0;
      dig3 <= 4'd0;
    end else if(~dig3_carry&en) // Only run the counter if en high and not at 999
    begin
      if(dig2_carry) // If dig2 and dig1 are 9's
      begin
        dig3 <= dig3 + 1; // Increment dig3
        dig2 <= 0; // Reset the lower digits
        dig1 <= 0;

      end else if(dig1_carry) // If dig1 is a 9
      begin
        dig2 <= dig2 + 1; // Increment dig2
        dig1 <= 0; // Reset lower digits

      end else // If no carry-magic had to occur
      begin
        dig1 <= dig1 + 1; // Count normally
      end
    end
  end

  endmodule