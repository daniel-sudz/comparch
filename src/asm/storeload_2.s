addi  x1, x0, 255              # x01 = 255 (32'b00000000000000000000000011111111)
addi  x2, x0, 1024             # x02 = 1024 
sw    x1, 0(x2)                # (MEM:1024) = 255 (32'b00000000000000000000000011111111)
lb    x3, 0(x2)                # x03 = -1 (32'b11111111111111111111111111111111)
lh    x4, 0(x2)                # x04 = 255 (32'b00000000000000000000000011111111)
lw    x5, 0(x2)                # x05 = 255 (32'b00000000000000000000000011111111)
lbu   x6, 0(x2)                # x06 = 255 (32'b00000000000000000000000011111111)
lhu   x7, 0(x2)                # x07 = 255 (32'b00000000000000000000000011111111)

# test partial stores
addi  x10, x0, -1              # x10 = -1 (32'b11111111111111111111111111111111)
addi  x11, x0, 1028            # x11 = 1028

# zero out the memory
addi  x12, x0, 0               # x12 = 0 (32'b00000000000000000000000000000000)
addi  x13, x0, 0               # x13 = 0 (32'b00000000000000000000000000000000)
addi  x14, x0, 0               # x14 = 0 (32'b00000000000000000000000000000000)

# store partial
sw    x10, 0(x11)              # (MEM:1028) = -1 (32'b11111111111111111111111111111111)
sh    x10, 4(x11)              # (MEM:1032) = 65535 (32'b00000000000000001111111111111111)
sb    x10, 8(x11)              # (MEM:1036) = 255 (32'b00000000000000000000000011111111)

# read full
lw    x12, 0(x11)              # x12 = -1 (32'b11111111111111111111111111111111)
lw    x13, 4(x11)              # x13 =  32'bXXXXXXXXXXXXXXXX1111111111111111
lw    x14, 8(x11)              # x14 = -1 (32'bXXXXXXXXXXXXXXXXXXXXXXXX11111111)


#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT| Register File State :)                |
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT|    x00, zero = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x01, ra = 0x000000ff (       255)|
#TESTASSERTOUTPUT|      x02, sp = 0x00000400 (      1024)|
#TESTASSERTOUTPUT|      x03, gp = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x04, tp = 0x000000ff (       255)|
#TESTASSERTOUTPUT|      x05, t0 = 0x000000ff (       255)|
#TESTASSERTOUTPUT|      x06, t1 = 0x000000ff (       255)|
#TESTASSERTOUTPUT|      x07, t2 = 0x000000ff (       255)|
#TESTASSERTOUTPUT|      x08, s0 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x09, s1 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x10, a0 = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x11, a1 = 0x00000404 (      1028)|
#TESTASSERTOUTPUT|      x12, a2 = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x13, a3 = 0xxxxxffff (         X)|
#TESTASSERTOUTPUT|      x14, a4 = 0xxxxxxxff (         X)|
#TESTASSERTOUTPUT|      x15, a5 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x16, a6 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x17, a7 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x18, s2 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x19, s3 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x20, s4 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x21, s5 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x22, s6 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x23, s7 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x24, s8 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x25, s9 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|     x26, s10 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|     x27, s11 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x28, t3 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x29, t4 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x30, t5 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x31, t6 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|---------------------------------------|