# Source makefile: https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# Help ghdl: https://ghdl.github.io/ghdl/quick_start/simulation/DLXModelSuite.html

# Need to install ghdl and gtkwave

# vhdl files
FILES = source/*
VHDLEX = .vhd

# package
PACKAGE = package/controller_IT_package

# testbench
TB_FILE = interface_tb
TB_PATH = testbench/${TB_FILE}$(VHDLEX)


#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --std=08

SIMDIR = simulation
STOP_TIME = 50ns
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

syntax:
	$(GHDL_CMD) -s  $(GHDL_FLAGS) --workdir=simulation --work=work $(FILES)

compile:
	$(GHDL_CMD) -i --workdir=simulation $(PACKAGE)$(VHDLEX)
	$(GHDL_CMD) -i --workdir=simulation $(TB_PATH) $(FILES)
#	-i [OPTS] FILEs    Import units of FILEs
	$(GHDL_CMD) -m  -g --workdir=simulation $(TB_FILE)
#	-m [OPTS] UNIT [ARCH]  Make UNIT
#		 -g Generate debugging informations

make:
	@mkdir simulation
	make compile

run:
	$(GHDL_CMD) -r  -g --workdir=simulation $(TB_FILE) --wave=./$(SIMDIR)/wave.ghw 
#	-r,--elab-run [OPTS] UNIT [ARCH] [RUNOPTS]  Run UNIT

view:
	gtkwave ./$(SIMDIR)/wave.ghw

clean:
	@$(GHDL_CMD) --clean --workdir=simulation --work=work
	@rm -rf $(SIMDIR)

analyze:
	$(GHDL_CMD) -a --workdir=simulation $(PACKAGE)$(VHDLEX)
	$(GHDL_CMD) -a --workdir=simulation source/interface_read.vhd
	$(GHDL_CMD) -a --workdir=simulation $(TB_PATH)
