addi  x1, x0, -100             # x01 = -100
addi  x2, x0, 1024             # x02 = 1024
sw  x1, 0(x2)                  # (MEM:1024) = -100
lw  x3, 0(x2)                  # x03 = -100
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT| Register File State :)                |
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT|    x00, zero = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x01, ra = 0xffffff9c (      -100)|
#TESTASSERTOUTPUT|      x02, sp = 0x00000400 (      1024)|
#TESTASSERTOUTPUT|      x03, gp = 0xffffff9c (      -100)|
#TESTASSERTOUTPUT|      x04, tp = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x05, t0 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x06, t1 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x07, t2 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x08, s0 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x09, s1 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x10, a0 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x11, a1 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x12, a2 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x13, a3 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x14, a4 = 0x00000000 (         0)|
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