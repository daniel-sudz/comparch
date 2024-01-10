addi  x1, x0, 50            # x01 = 50

loop_head:
addi    x2, x2, 1           # x02 ++
beq     x2, x1, loop_end
beq     x0, x0, loop_head
loop_end:
                            # x02 = 50