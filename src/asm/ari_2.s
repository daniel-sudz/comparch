# integrated test file courtesy of Ari Bobesh @Olin College of Engineering

addi  x1, x0, -1   # x01 = -1
addi  x2, x0, 35   # x02 = 35
jalr   x27,x1,13
xori  x3, x2, 68   # x03 = 103
ori   x4, x2, 17   # x04 = 51
andi  x5, x2, 17   # x05 = 1
slli  x6, x1, 8    # x06 = -256
srli  x7, x3, 2    # x07 = 25
srai  x8, x6, 6    # x08 = -4
slti  x9, x1, 35   # x09 = 1
sltiu x10, x1, 35  # x10 = 0
add   x11, x1, x1  # x11 = -2
sub   x12, x1, x1  # x12 = 0
xor   x13, x1, x12 # x13 = -1
or    x14, x2, x3  # x14 = 103
and   x15, x2, x3  # x15 = 35
addi  x16, x0, 4   # x16 = 4
sll   x17, x2, x16 # x17 = 560 
srl   x18, x3, x16 # x18 = 6
sra   x19, x6, x16 # x19 = -16
slt   x20, x1, x2  # x20 = 1
sltu  x21, x1, x2  # x20 = 0
loop_head:
beq     x22, x2, loop_end
addi    x22, x22, 1
jal		x28, loop_head
loop_end:
addi    x29, x29, 420
loop_head2:
addi    x23, x23, -1
bne     x23, x8, loop_head2
addi    x30, x30, 69
lw      x31, 24(x0)     #8426259
sw      x30, 760(x0)    #69
lw      x26, 776(x19)   #69
sw      x29, -16(x17)   #420
sb      x16, 544(x0)    #4
lw      x25, 544(x0)    #260
sh      x31, 126(x29)   #37651
lw      x24, 800(x6)    #-1827471100
#stage 2 testing, overwriting register file entries
lb      x8,  803(x6)    #-109
lbu     x9,  803(x6)    #147
lh      x10,  802(x6)    #-27885
lhu     x11,  802(x6)    #37651
#   x12 should remain zero
blt     x6, x5, add_one   #test -256<1
addi    x12, x12, 1     #should not run
add_one:
bgeu     x6, x5, add_two   #test big_number>1
addi    x12, x12, 2     #should not run
add_two:
bltu     x19, x23, add_four   #test -16<-4
addi    x12, x12, 4     #should not run
add_four:
bge     x19, x19, add_eight   #test -16=-16
addi    x12, x12, 8     #should not run
add_eight:
bge     x19, x8, add_sixteen   #test -16>-109
addi    x12, x12, 16     #should not run
add_sixteen:
bltu     x15, x14, add_more   #test 35<103
addi    x12, x12, 32     #should not run
add_more:
auipc   x21, 0
auipc   x22, 2048 #8388608+216=8388824
lui     x23, 42069 #172314624
nop

trap:
beq x0, x0, trap

#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT| Register File State :)                |
#TESTASSERTOUTPUT|---------------------------------------|
#TESTASSERTOUTPUT|    x00, zero = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x01, ra = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x02, sp = 0x00000023 (        35)|
#TESTASSERTOUTPUT|      x03, gp = 0x00000067 (       103)|
#TESTASSERTOUTPUT|      x04, tp = 0x00000033 (        51)|
#TESTASSERTOUTPUT|      x05, t0 = 0x00000001 (         1)|
#TESTASSERTOUTPUT|      x06, t1 = 0xffffff00 (      -256)|
#TESTASSERTOUTPUT|      x07, t2 = 0x00000019 (        25)|
#TESTASSERTOUTPUT|      x08, s0 = 0xffffff93 (      -109)|
#TESTASSERTOUTPUT|      x09, s1 = 0x00000093 (       147)|
#TESTASSERTOUTPUT|      x10, a0 = 0xffff9313 (    -27885)|
#TESTASSERTOUTPUT|      x11, a1 = 0x00009313 (     37651)|
#TESTASSERTOUTPUT|      x12, a2 = 0x00000000 (         0)|
#TESTASSERTOUTPUT|      x13, a3 = 0xffffffff (        -1)|
#TESTASSERTOUTPUT|      x14, a4 = 0x00000067 (       103)|
#TESTASSERTOUTPUT|      x15, a5 = 0x00000023 (        35)|
#TESTASSERTOUTPUT|      x16, a6 = 0x00000004 (         4)|
#TESTASSERTOUTPUT|      x17, a7 = 0x00000230 (       560)|
#TESTASSERTOUTPUT|      x18, s2 = 0x00000006 (         6)|
#TESTASSERTOUTPUT|      x19, s3 = 0xfffffff0 (       -16)|
#TESTASSERTOUTPUT|      x20, s4 = 0x00000001 (         1)|
#TESTASSERTOUTPUT|      x21, s5 = 0x000000d4 (       212)|
#TESTASSERTOUTPUT|      x22, s6 = 0x008000d8 (   8388824)|
#TESTASSERTOUTPUT|      x23, s7 = 0x0a455000 ( 172314624)|
#TESTASSERTOUTPUT|      x24, s8 = 0x93130104 (-1827471100)|
#TESTASSERTOUTPUT|      x25, s9 = 0x00000104 (       260)|
#TESTASSERTOUTPUT|     x26, s10 = 0x00000045 (        69)|
#TESTASSERTOUTPUT|     x27, s11 = 0x0000000c (        12)|
#TESTASSERTOUTPUT|      x28, t3 = 0x00000064 (       100)|
#TESTASSERTOUTPUT|      x29, t4 = 0x000001a4 (       420)|
#TESTASSERTOUTPUT|      x30, t5 = 0x00000045 (        69)|
#TESTASSERTOUTPUT|      x31, t6 = 0x00809313 (   8426259)|
#TESTASSERTOUTPUT|---------------------------------------|