/*================================================
Thomas Gorham
ECE 441 Spring 2017
Project 2 - lfsr
Description: This module implements a LFSR for
the generation of pseudorandom numbers.
It will use an 8 bit register with the polynomial
x^8+x^6+x^5+x^4+1
================================================*/
`timescale 100 ns / 1 ns


module lfsr(clk, ar, sr, q);
  /*======================================
  Input/Output Declaration
  ======================================*/
  input clk, ar;
  output q; // Output clocks
  output reg  [7:0]  sr; // Need a 26 bit counter reg

  /*======================================
  Internal wires/registers
  ======================================*/
  wire polynomial;

  /*======================================
  Asynchronous Logic
  ======================================*/
  assign polynomial = sr[7]^sr[5]^sr[4]^sr[3]; // 8, 6, 5, 4
  assign q = sr[7];

  /*======================================
  Synchronous Logic
  ======================================*/
  always @ (posedge clk or negedge ar)
    begin
      if(~ar) // If reset has negedge down to level 0,
        begin
          sr <= 0'b00000001;
        end
      else
        begin
          sr <= { sr[6:0], polynomial };
        end
    end

endmodule