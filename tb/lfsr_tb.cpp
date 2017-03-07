#include "Vlfsr.h"
#include "verilated.h"
#include "verilated_vcd_c.h"


int main(int argc, char **argv, char **env) {
  /*======================================
  Initialize test variables
  ======================================*/
  int i;
  int failures;
  int numberfound[256];

  failures = 0;

  for(i=1;i<256;i++){
    numberfound[i]=0;
  }

  /*======================================
  Verilator Initialization
  ======================================*/
  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vlfsr* top = new Vlfsr;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("lfsr.vcd");

  /*======================================
  Module input initialization
  ======================================*/
  top->clk = 1;
  top->ar = 1;

  /*======================================
  Simulation Loop
  ======================================*/
  for(i=0;i<1000;i++)
  {
    // Toggle the clock indefinitely
    // Pull reset low for the first few iterations
    top->ar = (i > 2); // ar is 0 when i <2. Gotta have resets
    top->clk = !top->clk; // Toggle the clock

    top->eval ();

    numberfound[top->sr]=1;
    if( ( ( top->sr&(1<<7) ) != 0 ) != top->q )
    {
      printf("WARNING: q is not the MSB as expected\n");
      failures++;
    }
    if (Verilated::gotFinish())  exit(0);
  }

  /*======================================
  Simulation complete - Print results
  ======================================*/
  for(i=1;i<256;i++){
    if(numberfound[i]==0){
      printf("LFSR is not maximal: Missing %d\n", i);
      failures++;
    }
  }

  if(failures==0){
    printf("PASSED: LFSR is maximal\n");
  }else{
    printf("FAILED: Something went wrong\n");
  }

  printf("Simulation complete\n");

  tfp->close();
  exit(0);
}