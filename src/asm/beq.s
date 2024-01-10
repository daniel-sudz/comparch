addi  x1, x0, 5            # x01 = 5

addi    x8, x0, 0           # x08 = 0
loop_head:
addi    x8, x8, 1           # x08 ++
beq     x8, x1, loop_end
beq     x0, x0, loop_head
loop_end:
                            # x08 = 5