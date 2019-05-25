li a0, 0x00001000
li t0, 0x12345678
li t2, 0x87654321
csrrw t1, 0x0, t0
csrrw t3, 0x0, t2
sw t1, 0(a0)
sw t3, 4(a0)