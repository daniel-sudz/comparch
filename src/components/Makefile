SHELL=/bin/bash
IVERILOG=iverilog -g2012 -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -y./ -y./tests -Y.sv -I./ -DSIMULATION
VVP=vvp
VVP_POST=-fst
WAVES=gtkwave --rcvar 'fontname_signals Monospace 20' --rcvar 'fontname_waves Monospace 20'

# Some Makefile magic. Look it up if you are curious about build systems!
.PHONY: clean

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil

#########################################################################
## Misc. Combinational Components
#########################################################################

# Sample file to compile
test_sample : tests/test_sample.sv sample*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

# Test mux
test_mux : tests/test_mux.sv mux*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

all: test_sample test_mux