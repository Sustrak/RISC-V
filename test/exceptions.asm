xor s11, s11, s11
# @ miss aligned
li t0, 0x00010001
sw t0, 0(t0)
lw t1, 0(t0)
# illegal instructions
csrr t1, 0xF00