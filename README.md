# Winter Break Comparch Speedrun

## Components Checklist

### CPU
- R-types (validated againt https://github.com/avinash-nonholonomy/olin-cafe-f23/blob/main/asm/irtypes.s)
  - [x] add
  - [x] sub
  - [x] xor
  - [x] or
  - [x] and
  - [x] sll
  - [x] srl
  - [x] sra
  - [x] slt
  - [x] sltu
- I-types (validated against https://github.com/avinash-nonholonomy/olin-cafe-f23/blob/main/asm/irtypes.s)
  - [x] addi
  - [x] xori
  - [x] ori
  - [x] andi
  - [x] slli
  - [x] srli
  - [x] srai
  - [x] slti
  - [x] sltiu
- Memory-Types (Loads/Stores)
  - [ ] lw
  - [ ] sw
  - [ ] *lb*
  - [ ] *lh*
  - [ ] *lbu*
  - [ ] *lhu*
  - [ ] *sb*
  - [ ] *sh*

- B-types (Branches)
  - [ ] beq
  - [ ] bne
  - [ ] *blt*
  - [ ] *bge*
  - [ ] *bltu*
  - [ ] *bgeu*
- J-types (Jumps)
  - [ ] jal
  - [ ] jalr (technically an i-type)
- U-types (Upper immediates)
  - [ ] *lui*
  - [ ] *auipc*

### ALU
- [x] 32bit (structural with SLTU/overflow)

### Shifters
- sll
  - [x] 32bit (structural with mux-32)
  - [ ] any
- srl
  - [x] 32bit (structural with mux-32)
  - [ ] any
- sra
  - [x] 32bit (structural with mux-32)
  - [ ] any



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
- [ ] Chapter 1
- [ ] Chapter 2
- [ ] Chapter 3
- [ ] Chapter 4
- [ ] Chapter 5
- [ ] Chapter 6
- [ ] Chapter 7
