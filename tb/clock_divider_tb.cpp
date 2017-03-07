#include "Vclock_divider.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  /*======================================
  Initialize test variables
  ======================================*/
  int i;
  int i_saved_x;
  int i_saved_y;
  int prevx;
  int prevy;
  unsigned int x_period;
  unsigned int y_period;

  i_saved_x = 0;
  i_saved_y = 0;

  prevx = 0;
  prevy = 0;

  x_period = 0;
  y_period = 0;

  /*======================================
  Verilator Initialization
  ======================================*/
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vclock_divider* top = new Vclock_divider;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("clock_divider.vcd");

  /*======================================
  Module input initialization
  ======================================*/
  top->clk = 1;
  top->ar = 1;


  /*======================================
  Simulation Loop
  ======================================*/
  while(x_period == 0 || y_period == 0)
  {
    // Toggle the clock indefinitely
    // Pull reset low for the first few iterations
    top->ar = (i > 2); // ar is 0 when i <2. Gotta have resets
    top->clk = !top->clk; // Toggle the clock
    top->eval ();

    // If there is a rising clock edge on x
    if(top->x == 1 && prevx == 0)
    {
      if(i_saved_x!=0)
      {
        x_period = (i-i_saved_x)/2;
      }
      i_saved_x = i;
    }

    // If there is a rising clock edge on y
    if(top->y == 1 && prevy == 0)
    {
      if(i_saved_y!=0)
      {
        y_period = (i-i_saved_y)/2;
      }
      i_saved_y = i;
    }

    prevx = top->x;
    prevy = top->y;

    i++;
    if (Verilated::gotFinish())  exit(0);
  }

  /*======================================
  Simulation complete - Print results
  ======================================*/

  // Print the period of each clock output
  printf("X Period: %d\n", x_period);
  printf("Y Period: %d\n", y_period);

  tfp->close();
  exit(0);
}