/*================================================
Thomas Gorham
ECE 441 Spring 2017
Project 2 - Clock divider
Description: This module accepts a 50MHz clock
signal and outputs two clocks: one with a 2 sec
period and the other with a 1kHz frequency.
================================================*/
`timescale 100 ns / 1 ns


module clock_divider(clk, ar, x, y);
  /*======================================
  Input/Output Declaration
  ======================================*/
  parameter width_x = 26;
  parameter halfperiod_x = 26'd50000000;

  parameter width_y = 15;
  parameter halfperiod_y = 15'd25000;
  /*======================================
  Input/Output Declaration
  ======================================*/
  input clk, ar;
  output reg x, y; // Output clocks

  /*======================================
  Internal wires/registers
  ======================================*/
  reg  [width_x-1:0]  ctr_x; // Need a 26 bit counter reg
  reg  [width_y-1:0]  ctr_y;

  /*======================================
  Synchronous Logic
  ======================================*/
  always @ (posedge clk or negedge ar)
    begin
      if(~ar) // If reset has negedge down to level 0,
        begin
          ctr_x <= 0; // Put ctr and output in known state
          ctr_y <= 0;
          x <= 0;
          y <= 0;
        end
      else
        begin
          if(ctr_x>=halfperiod_x-1) // If the counter hits 25M
            begin
              x <= ~x; // Flip output
              ctr_x <= 0; // Reset ctr
            end
          else begin
            ctr_x <= ctr_x + 1; // Inc ctr
          end

          if(ctr_y>=halfperiod_y-1)
            begin
              y <= ~y;
              ctr_y <= 0;
            end
          else begin
            ctr_y <= ctr_y + 1;
          end
        end
        
    end

endmodule