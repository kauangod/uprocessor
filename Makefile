FILES = $(shell find ula/source -type f -name "*.vhd")

TESTBENCHPATH = ula/testbench/${TESTBENCHFILE}*
TESTBENCHFILE = ULA_tb
WORKDIR = work

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys --warn-no-vital-generic --workdir=$(WORKDIR)

STOP_TIME = 500ns
# Simulation break condition
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run view

make:
	@mkdir -p $(WORKDIR)
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(FILES)
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(TESTBENCHPATH)
	@$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCHFILE)

run:
	@$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=$(WORKDIR) $(TESTBENCHFILE) --vcd=$(TESTBENCHFILE).vcd $(GHDL_SIM_OPT)
	@mv $(TESTBENCHFILE).vcd $(WORKDIR)/

view:
	@$(WAVEFORM_VIEWER) --dump=$(WORKDIR)/$(TESTBENCHFILE).vcd

clean:
	@rm -rf $(WORKDIR) *.exe *.o *.lst *.cf