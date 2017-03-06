#include "Vclock_divider.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  int i;
  int i_saved;
  unsigned int numchanges;
  int prevq;

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vclock_divider* top = new Vclock_divider;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("clock_divider.vcd");
  // initialize simulation inputs
  top->clk = 1;
  top->ar = 1;

  i_saved = 0;
  numchanges = 0;
  // run simulation for 100 clock periods
  while(numchanges<4)
  {
    // Toggle the clock indefinitely
    // Pull reset low for the first few iterations
    top->ar = (i > 2); // ar is 0 when i <2. Gotta have resets
    top->clk = !top->clk; // Toggle the clock
    top->eval ();

    // Verify results
    if (top->q != prevq)
    {
      if(top->q == 1){
        printf("Rising edge on output q\n");
        if(i_saved!=0){
          printf("Period %d rising clock edges\n", (i-i_saved)/2); // Divide by 2 because i represents all edged of clk. Not just rising.
        }else{
          printf("First edge. Ignoring.\n");
        }
        i_saved = i;
        numchanges++;
      }
      prevq = top->q;
    }

    i++;
    if (Verilated::gotFinish())  exit(0);
  }
  tfp->close();
  exit(0);
}