jal x1, jump      # x01 = 4

addi x1, x1, 10   # x1 += 10
beq x0, x0, trap  # halt

jump:
jalr x1, x1, 0    # x1 = 20, jump to addi 

trap: 

