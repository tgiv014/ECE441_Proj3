/*================================================
Thomas Gorham
ECE 441 Spring 2017
Project 2 - ctr_fsm
Description: This module implements a state
machine with outputs intended to drive the
3 digit bcd counter used in this project.
================================================*/
`timescale 100 ns / 1 ns


module ctr_fsm(clk, ar, start, stop, ctr_en, ctr_ar);
  /*======================================
  Parameters
  ======================================*/
  parameter [1:0] IDLE=2'b00, PRERUN=2'b01, RUN=2'b10, STOPPED=2'b11;

  parameter start_assert = 1'b1; // LED is on when line is low, so start on low
  parameter stop_assert = 1'b0; // Pushbutton down -> line high
  /*======================================
  Input/Output Declaration
  ======================================*/
  input clk, ar, start, stop;
  output ctr_en, ctr_ar;

  /*======================================
  Internal wires/registers
  ======================================*/
  reg [1:0] state;

  /*======================================
  Asynchronous Logic
  ======================================*/
  // Avoiding setting the outputs in the always block
  // We should never have to
  assign ctr_en = (state==RUN); // Enable is high when in run
  assign ctr_ar = ~(state==PRERUN|state==IDLE); // Pull ar low when in prerun

  /*======================================
  Synchronous Logic
  ======================================*/
  always @ (posedge clk or negedge ar)
  begin
    if(~ar)
    begin
      state <= IDLE; // Always reset to idle
    end else
    begin
      case(state)
        IDLE:begin
          if(start==start_assert) // IDLE only advances when start "button" asserted
          begin
            state<=PRERUN;
          end else
          begin
            state<=IDLE;
          end
        end
        PRERUN:begin
          if(stop==stop_assert)
          begin
            state<=STOPPED; // If the stop button is already down, go to stopped.
            // Odds are the user was holding the button down and just waiting.
            // Wouldn't be a very fun game if you always won.
          end else
          begin
            state<=RUN; // Ready to run!
          end
        end
        RUN:begin // State is run
          if(stop==stop_assert) // If stop button pressed, stop
          begin
            state<=STOPPED;
          end
			 else begin
            state<=RUN;
          end
        end
		  default:begin // State is stopped
          if(start==~start_assert) // Start has gone back to 0 (To Handle when LFSR is still 1)
          begin
            state<=IDLE;
          end else
          begin
            state<=STOPPED; // Otherwise just stay put
          end
        end
      endcase
    end
  end

  endmodule