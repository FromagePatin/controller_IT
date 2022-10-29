# Source makefile: https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# Help ghdl: https://ghdl.github.io/ghdl/quick_start/simulation/DLXModelSuite.html

# Need to install ghdl and gtkwave

# vhdl files
FILES = source/*
VHDLEX = .vhd

# testbench
TESTBENCHPATH = testbench/${TESTBENCHFILE}$(VHDLEX)
TESTBENCHFILE = priority_solver_tb

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --std=08

SIMDIR = simulation
STOP_TIME = 500ns
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run #view

syntax:
	$(GHDL_CMD) -s  $(GHDL_FLAGS) --workdir=simulation --work=work $(FILES)

compile:
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
#	-i [OPTS] FILEs    Import units of FILEs
	$(GHDL_CMD) -m  -g $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE)
#	-m [OPTS] UNIT [ARCH]  Make UNIT
#		 -g Generate debugging informations

make:
	@mkdir simulation
	make compile

run:
	$(GHDL_CMD) -r  -g $(GHDL_FLAGS) --workdir=simulation $(TESTBENCHFILE) --wave=./$(SIMDIR)/wave.ghw 
#	-r,--elab-run [OPTS] UNIT [ARCH] [RUNOPTS]  Run UNIT

view:
	gtkwave ./$(SIMDIR)/wave.ghw

clean:
	@$(GHDL_CMD) --clean --workdir=simulation --work=work
	@rm -rf $(SIMDIR)

