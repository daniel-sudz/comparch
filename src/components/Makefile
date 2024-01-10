SHELL=/bin/bash
IVERILOG=iverilog -g2012 -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -y./ -y./tests/provided -Y.sv -I src/alu -I src/cpu/types -DSIMULATION
VVP=vvp
VVP_POST=-fst
WAVES=gtkwave --rcvar 'fontname_signals Monospace 20' --rcvar 'fontname_waves Monospace 20'
TOOLS_ROOT=../../olin-cafe-f23/tools

# Some Makefile magic. Look it up if you are curious about build systems!
.PHONY: clean

clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil

#########################################################################
## Misc. Combinational Components
#########################################################################

# Compile only
compile : src/alu/alu_types.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin

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

# Test alu
test_alu_provided: tests/provided/test_alu.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_alu_all: test_alu_provided

# Test register_file
test_register_file_our: tests/our/test_register_file.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_register_file_provided: tests/provided/test_register_file.sv src/**/*.sv
	${IVERILOG} $^ -o $@.bin && ${VVP} $@.bin ${VVP_POST}

test_register_file_all: test_register_file_our test_register_file_provided


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Instruction Type Tests
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Assembles .s (human readable) files into .memh (Verilog readable binary) files.
%.memh: ../asm/%.s $(TOOLS_ROOT)/assembler.py $(TOOLS_ROOT)/rv32i.py
	$(TOOLS_ROOT)/assembler.py $< -o ../asm/out/$@

# The actual simulator for rv32i
rv32_simulator: tests/provided/rv32_simulator.sv src/**/*.sv
	${IVERILOG} -y ./rv32 $^ -s $@ -o $@.bin

# Runs the assembled .memh files through the simulator and writes out the register file state
%.result: %.memh rv32_simulator
	./rv32_simulator.bin +max_cycles=10000 +initial_memory=../asm/out/$< ${VVP_POST} 2>&1 | tee ../asm/test/$(basename $<).result

# Validates that the simulator output is as expected
%.validate: %.result
	node ../asm/validate.js $(basename $<).s test/$< 

test_rv32_ir_types: addi.validate itypes.validate irtypes.validate
test_rv32_utypes: utypes.validate
test_rv32_branch: beq.validate bne.validate blt.validate bge.validate bgeu.validate bltu.validate
test_rv32_jal: jal_jalr.validate

test_rv32_all: test_rv32_ir_types storeload.validate test_rv32_branch test_rv32_jal test_rv32_utypes

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Instruction Type Tests
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

all: test_sample test_muxes_all test_decoders_all test_shifters_all test_comparators_all test_adders_all test_alu_all test_register_file_all test_rv32_all