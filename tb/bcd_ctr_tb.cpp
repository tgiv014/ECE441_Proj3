#include "Vbcd_ctr.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  /*======================================
  Initialize test variables
  ======================================*/
  unsigned int i;
  unsigned int j;
  unsigned int num;
  unsigned int prevnum;
  unsigned int prevstate;
  unsigned int failures;

  /*======================================
  Verilator Initialization
  ======================================*/
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vbcd_ctr* top = new Vbcd_ctr;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("bcd_ctr.vcd");

  /*======================================
  Module input initialization
  ======================================*/
  top->clk = 1;
  top->ar = 1;

  prevnum = 0;
  prevstate = 0;
  failures = 0;
  /*======================================
  Simulation Loop - Each iteration runs one rising edge
  ======================================*/
  for(i=0;i<2000;i++)
  {
    for(j=0;j<2;j++){
      top->ar = (i > 2); // ar is 0 when i <2. Gotta have resets
      top->clk = j; // Toggle the clock (always)
      top->start = (i==10) || (i==1500); // Start button pushed at cycles 10 and 1500
      top->stop = (i==1600);
      top->eval ();
    }
    num = top->dig3*100+top->dig2*10+top->dig1;
    printf("%d    State %d    Clock %d    i %d\n", num, top->state, top->clk, i);

    prevstate=top->state;
    prevnum=num;
    if (Verilated::gotFinish())  exit(0);
  }

  /*======================================
  Simulation complete - Print results
  ======================================*/
  if(failures==0){
    printf("PASSED: bcd counter works as expected\n");
  }else{
    printf("FAILED: Something went wrong\n");
  }

  printf("Simulation complete\n");

  tfp->close();
  exit(0);
}