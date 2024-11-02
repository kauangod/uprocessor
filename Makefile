FILES = adder mux16b 
TESTBENCH = adder_tb
#MAIN = ULA $(MAIN:=.vhd)
WORKDIR = work

GHDL_CMD = ghdl
GHDL_FLAGS = --workdir=$(WORKDIR)
WAVEFORM_VIEWER = gtkwave

all: clean make view

make:
	@mkdir -p work
	@$(GHDL_CMD) -a $(GHDL_FLAGS) $(addprefix ula/source/, $(FILES:=.vhd)) $(addprefix ula/testbench/, $(TESTBENCH:=.vhd))
	@$(GHDL_CMD) -e $(GHDL_FLAGS) $(TESTBENCH)
	@$(GHDL_CMD) -r $(GHDL_FLAGS) $(TESTBENCH) --wave=$(TESTBENCH).ghw
	@mv $(TESTBENCH).ghw $(WORKDIR)/
view: 
	@$(WAVEFORM_VIEWER) $(addprefix $(WORKDIR)/, $(TESTBENCH:=.ghw))

clean:
	@rm -rf work *.o *.lst