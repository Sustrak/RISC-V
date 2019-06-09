li a0 0x10010000
li t0, 14
li t1, 5
mul t2, t0, t1
li t1, -5
sw t2, 0(a0)
mul t2, t0, t1
sw t2, 4(a0)
mulh t2, t0, t1
sw t2, 8(a0)
mulhu t2, t0, t1
sw t2, 12(a0)
li t0, -14
mulhsu t2, t1, t0
sw t2, 16(a0)
li t0, 56
li t1, -7
div t2, t0, t1
sw t2, 20(a0)
divu t2, t0, t1
sw t2, 24(a0)
li t1, -9
rem t2, t0, t1
sw t2, 28(a0)
remu t2, t0, t1
sw t2, 32(a0)
li t2, 0xF0F0F0F0
sw t2, 36(a0)