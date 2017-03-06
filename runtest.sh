#!/bin/bash

TESTMODULE=$1

VERILOG_SUFFIX=.v
CPP_SUFFIX=_tb.cpp
MAKE_SUFFIX=.mk

echo "Running Test on $TESTMODULE.v"
echo ""

rm -R obj_dir/

verilator -Wall --cc --trace $TESTMODULE$VERILOG_SUFFIX --exe tb/$TESTMODULE$CPP_SUFFIX

make -j -C obj_dir/ -f V$TESTMODULE$MAKE_SUFFIX V$TESTMODULE

echo "******************"
echo "Begin Test Output:"
echo "******************"
obj_dir/V$TESTMODULE