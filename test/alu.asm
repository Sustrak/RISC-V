li a0, 0x10010000
# ADD
li t0, 120
li t1, 80
add t2, t0, t1
sw t2, 0(a0)
# SUB
sub t2, t0, t1
sw t2, 4(a0)
# XOR
xor t2, t0, t1
sw t2, 8(a0)
# OR
or t2, t0, t1
sw t2, 12(a0)
# AND
and t2, t0, t1
sw t2, 16(a0)
# SLT
slt t2, t1, t0
sw t2, 20(a0)
# SLTU
li t3, -1
li t4, -5
sltu t2, t4, t3
sw t2, 24(a0)
# SRA
li t4, 1
li t1, 5
li t5, -40
sra t2, t4, t3		# 1 >> -1
sw t2, 28(a0)
sra t2, t0, t1		# 120 >> 5
sw t2, 32(a0)
sra t2, t5, t1		# -40 >> 5
sw t2, 36(a0)
# SLL
sll t2, t1, t4		# 5 << 1
sw t2, 40(a0)
sll t2, t1, t3		# 5 << -1
sw t2, 44(a0)