addi x1, x0, 17
addi x10, zero, -16
slli x2, x1, 4
slti x3, x2, 1000
sltiu x4, x2, 1000
xori x5, x2, 479
srli x6, x10, 4
srai x7, x10, 4
ori x8, x2, 2044
andi x9, x8, 100
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT| Register File State :)                |
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT|    x00, zero = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x01, ra = 0x00000011 (        17)|
#TESTASSERTOUTPUT|      x02, sp = 0x00000110 (       272)|
#TESTASSERTOUTPUT|      x03, gp = 0x00000001 (         1)|
#TESTASSERTOUTPUT|      x04, tp = 0x00000001 (         1)|
#TESTASSERTOUTPUT|      x05, t0 = 0x000000cf (       207)|
#TESTASSERTOUTPUT|      x06, t1 = 0x0fffffff ( 268435455)|
#TESTASSERTOUTPUT|      x07, t2 = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x08, s0 = 0x000007fc (      2044)|
#TESTASSERTOUTPUT|      x09, s1 = 0x00000064 (       100)|
#TESTASSERTOUTPUT|      x10, a0 = 0xfffffff0 (       -16)|
#TESTASSERTOUTPUT|      x11, a1 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x12, a2 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x13, a3 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x14, a4 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x15, a5 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x16, a6 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x17, a7 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x18, s2 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x19, s3 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x20, s4 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x21, s5 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x22, s6 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x23, s7 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x24, s8 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x25, s9 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|     x26, s10 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|     x27, s11 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x28, t3 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x29, t4 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x30, t5 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|      x31, t6 = 0xxxxxxxxx (         x)|
#TESTASSERTOUTPUT|---------------------------------------|