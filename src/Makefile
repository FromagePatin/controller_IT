# Source makefile: https://github.com/jimtremblay/ghdl-example/blob/master/Makefile
# Help ghdl: https://ghdl.github.io/ghdl/quick_start/simulation/DLXModelSuite.html

# Need to install ghdl and gtkwave

# vhdl files
FILES = source/*
VHDLEX = .vhd

# testbench
TB_FILE = global_tb
TB_PATH = testbench/${TB_FILE}$(VHDLEX)

#GHDL CONFIG
GHDL_CMD = ghdl

SIMDIR = simulation
STOP_TIME = 10ns
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

#GHDL_FLAGS += $(GHDL_SIM_OPT)
GHDL_FLAGS  += --std=08
GHDL_FLAGS  += -fsynopsys


WAVEFORM_VIEWER = gtkwave

WORK=work

.PHONY: clean

all: clean make run #view

syntax:
	$(GHDL_CMD) -s  $(GHDL_FLAGS) --workdir=simulation --work=$(WORK) $(FILES)

compile:
	$(GHDL_CMD) -a $(GHDL_FLAGS) --workdir=simulation --work=$(WORK) $(FILES)
	$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=$(WORK) $(TB_PATH) $(FILES)
#	-i [OPTS] FILEs    Import units of FILEs
	$(GHDL_CMD) -m  -g $(GHDL_FLAGS) --workdir=simulation --work=$(WORK) $(TB_FILE)
#	-m [OPTS] UNIT [ARCH]  Make UNIT
#		 -g Generate debugging informations

make:
	@mkdir simulation
	make compile

run:
	$(GHDL_CMD) -r  -g $(GHDL_FLAGS) --workdir=simulation $(TB_FILE) --wave=./$(SIMDIR)/wave.ghw 
#	-r,--elab-run [OPTS] UNIT [ARCH] [RUNOPTS]  Run UNIT

view:
	gtkwave ./$(SIMDIR)/wave.ghw

clean:
	@$(GHDL_CMD) --clean --workdir=simulation --work=$(WORK)
	@rm -rf $(SIMDIR)

