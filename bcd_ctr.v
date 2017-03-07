/*================================================
Thomas Gorham
ECE 441 Spring 2017
Project 2 - bcd_ctr
Description: This module implements a 3 digit
bcd counter with FSM that 
================================================*/
`timescale 100 ns / 1 ns


module bcd_ctr(clk, ar, start, stop, dig1, dig2, dig3, state);
  /*======================================
  Parameters
  ======================================*/
  parameter IDLE = 0'b0;
  parameter RUN = 0'b1;

  /*======================================
  Input/Output Declaration
  ======================================*/
  input clk, ar, start, stop;
  output reg  [3:0]  dig1, dig2, dig3;
  output state;
  /*======================================
  Internal wires/registers
  ======================================*/
  reg state;

  /*======================================
  Asynchronous Logic
  ======================================*/
  assign dig1_carry = (dig1 == 4'd9);
  assign dig2_carry = dig1_carry&(dig2 == 4'd9);
  assign dig3_carry = dig2_carry&(dig3 == 4'd9);

  /*======================================
  Synchronous Logic
  ======================================*/
  always @ (posedge clk or negedge ar)
  begin
      if(~ar) // If reset has negedge down to level 0,
      begin
      state <= IDLE;

      dig1 <= 4'd0;
      dig2 <= 4'd0;
      dig3 <= 4'd0;
      end
      else begin
        // Not in reset - Service state machine
        case(state)
          // IDLE STATE - Only waiting for the start button
          IDLE: begin
            if(start)
            begin
            state<=RUN;
            dig1 <= 4'd0;
            dig2 <= 4'd0;
            dig3 <= 4'd0;
            end
          end

          // RUN STATE - Running Timer -> Returns to idle on stop
          default: begin // Using default - But really we care about RUN
            if(stop)
            begin
            state<=IDLE;
            end

            if(dig3_carry)
            begin
              state<=IDLE;
            end
            else if(dig2_carry)
            begin
              dig3 <= dig3 + 1;
              dig2 <= 0;
              dig1 <= 0;
            end
            else if(dig1_carry)
            begin
              dig2 <= dig2 + 1;
              dig1 <= 0;
            end
            else
            begin
              dig1 <= dig1 + 1;
            end
          end
          endcase
          end
          end

          endmodule