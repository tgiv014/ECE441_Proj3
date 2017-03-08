#include "Vctr_fsm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  /*======================================
  Initialize test variables
  ======================================*/
  unsigned int i;
  unsigned int j;
  unsigned int failures;

  /*======================================
  Verilator Initialization
  ======================================*/
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vctr_fsm* top = new Vctr_fsm;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("ctr_fsm.vcd");

  /*======================================
  Module input initialization
  ======================================*/
  top->clk = 1;
  top->ar = 1;
  top->start = 0;
  top->stop = 0;

  failures = 0;
  /*======================================
  Simulation Loop - Each iteration runs one rising edge
  ======================================*/
  for(i=0;i<100;i++)
  {
    for(j=0;j<2;j++){
      top->ar = (i > 2); // pull ar low for a few cycles
      top->clk = j; // Toggle the clock (always)

      top->start = (i==10)||(i==30); // Start the counter at iteration 10 and 30
      top->stop = (i==20)||(i>28&&i<32); // Stop the counter at 20 and 30

      top->eval ();
    }
    printf("ctr_en: %d    |    ctr_ar: %d    i: %d\n",top->ctr_en, top->ctr_ar, i);
    if (Verilated::gotFinish())  exit(0);
  }

  /*======================================
  Simulation complete - Print results
  ======================================*/
  if(failures==0){
    printf("PASSED: counter state machine works as expected\n");
  }else{
    printf("FAILED: Something went wrong\n");
  }

  printf("Simulation complete\n");

  tfp->close();
  exit(0);
}