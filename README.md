# Winter Break Comparch Speedrun

## Components Checklist

### CPU

Extensive unit test coverage for instruction in https://github.com/daniel-sudz/comparch/tree/main/src/asm including two large integrated test files. 

| R-types                       | I-types                                   |    Memory-types                    | Branches                        | Jumps                      | U-types
| ----------------------------  | ------------------------------------------| -----------------------------------| --------------------------------| ---------------------------| --------------------------------------|
| add   :white_check_mark:      | addi   :white_check_mark:                 |  lw  :white_check_mark:            |  beq   :white_check_mark:       | jal   :white_check_mark:   |  lui   :white_check_mark:             |
| sub   :white_check_mark:      | xori   :white_check_mark:                 |  sw  :white_check_mark:            |  bne   :white_check_mark:       | jalr  :white_check_mark:   |  auipc :white_check_mark:             |                 
| xor   :white_check_mark:      | ori    :white_check_mark:                 |  lb  :white_check_mark:            |  blt   :white_check_mark:       |                            |                                       |                 
| or    :white_check_mark:      | andi   :white_check_mark:                 |  lh  :white_check_mark:            |  bge   :white_check_mark:       |                            |                                       |                 
| and   :white_check_mark:      | slli   :white_check_mark:                 |  lbu :white_check_mark:            |  bltu  :white_check_mark:       |                            |                                       |                 
| sll   :white_check_mark:      | srli   :white_check_mark:                 |  lhu :white_check_mark:            |  bgeu  :white_check_mark:       |                            |                                       |                 
| srl   :white_check_mark:      | srai   :white_check_mark:                 |  sb  :white_check_mark:            |                                 |                            |                                       |                 
| sra   :white_check_mark:      | sltiu  :white_check_mark:                 |  sh  :white_check_mark:            |                                 |                            |                                       |                 
| slt   :white_check_mark:      |                                           |                                    |                                 |                            |                                       |                 
| sltu  :white_check_mark:      |                                           |                                    |                                 |                            |                                       |                 


### ALU
- [x] 32bit (structural with SLTU/overflow)

### Shifters
- [x] sll  (32bit structural with mux-32)
- [x] srl  (32bit structural with mux-32)
- [x] sra  (32bit structural with mux-32)

### Muxes
- [x] mux2 (gate level)
- [x] mux4 (binary design)
- [x] mux8 (binary design)
- [x] mux16 (binary design)
- [x] mux32 (binary design)

### Decoders
- [x] decoder_1_to_2 (gate level)
- [x] decoder_2_to_4 (binary design)
- [x] decoder_3_to_8 (binary design)
- [x] decoder_4_to_16 (binary design)
- [x] decoder_5_to_32 (binary design)

### Comparators
- [x] comparator_eq (gate level w/ codegen)
- [x] comparator_lt (gate level w/ codegen)

## Harris and Harris
- [x] Chapter 6
- [x] Chapter 7

## Class Lectures
- [x] 0x11: Memory, Microarchitecture
- [x] 0x12: Reflection, RISC-V
- 0x13: N/A Lecture Recording Missing from Archive
- [x] 0x14: RV32i Core review, Memory Managment
- [ ] 0x15: Branches, Jumps, Loops, Functions
- [ ] 0x16: Advance Topics in CPU Design


