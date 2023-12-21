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
test_sample : tests/test_sample.sv src/sample*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

# Test adders
test_adders_our : tests/our/test_adders.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_adders_provided : tests/provided/test_adder_1.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_adders_all: test_adders_our test_adders_provided

# Test mux
test_muxes_our : tests/our/test_muxes.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_muxes_provided : tests/provided/test_muxes.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_muxes_all: test_muxes_our test_muxes_provided

# Test decoders
test_decoders_our : tests/our/test_decoders.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_decoders_provided : tests/provided/test_decoders.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_decoders_all: test_decoders_our test_decoders_provided

# Test shifters
test_shifters_our: tests/our/test_shifters.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_shifters_provided: tests/provided/test_shifters.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_shifters_all:  test_shifters_our test_shifters_provided

# Test comparators
test_comparators_our: tests/our/test_comparators.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_comparators_provided: tests/provided/test_comparators.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_comparators_all:  test_comparators_our test_comparators_provided


all: test_sample test_muxes_all test_decoders_all test_shifters_all test_comparators_all test_adders_all