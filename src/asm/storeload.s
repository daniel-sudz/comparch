addi  x1, x0, -1                # x01 = -1
addi  x2, x0, -2                # x02 = -2
sw    x1, 0(x3E8)               # 3E8 (1000) = -1
sw    x2, 0(3EC)                # 3EC (1004) = -2
lw    x3, 0(x3E8)               # x03 = -1
lw    x4, 0(3EC)                # x04 = -1
