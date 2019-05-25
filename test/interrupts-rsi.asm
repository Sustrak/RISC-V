csrr t0, 0x342
li a0, 0x0800002C
sw zero, 0(a0)
li a0, 0x08000010
li a1, 0x08000030
addi s11, s11, 1
sw s11, 0(a0)
sw s11, 0(a1)
mret