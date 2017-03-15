/*================================================
Thomas Gorham

ECE 441 Spring 2017
Project 2 - Main

Description: This module instantiates all the
component modules used in this design.
================================================*/
`timescale 100 ns / 1 ns

module tld(clock, ar, button, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2, a3, b3, c3, d3, e3, f3, g3, led);
  input wire clock, ar, button;
  output wire a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2, a3, b3, c3, d3, e3, f3, g3, led;
  
  wire fast_clock, slow_clock, random_bit, ctr_en, ctr_ar;
  wire [3:0] dig1, dig2, dig3;
  
  // Clock divider takes in 50MHz clock and outputs 2Hz and 1kHz clocks
  clock_divider clkdiv ( .clk(clock), .ar(ar), .x(slow_clock), .y(fast_clock));

  lfsr shiftreg ( .clk(slow_clock), .ar(ar), .sr( ), .q(random_bit));

  ctr_fsm fsm (.clk(fast_clock), .ar(ar), .start(random_bit), .stop(button), .ctr_en(ctr_en), .ctr_ar(ctr_ar));

  bcd_ctr bcd (.clk(fast_clock), .en(ctr_en), .ar(ctr_ar), .dig1(dig1), .dig2(dig2), .dig3(dig3));

  sevseg_decoder decoder1 (.val(dig1), .a(a1), .b(b1), .c(c1), .d(d1), .e(e1), .f(f1), .g(g1));
  sevseg_decoder decoder2 (.val(dig2), .a(a2), .b(b2), .c(c2), .d(d2), .e(e2), .f(f2), .g(g2));
  sevseg_decoder decoder3 (.val(dig3), .a(a3), .b(b3), .c(c3), .d(d3), .e(e3), .f(f3), .g(g3));

  assign led = ctr_en;
endmodule
