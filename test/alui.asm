li a0, 0x10010000
# ADDI
addi t0, zero, 0xAB
sw t0, 0(a0)
# SLTI
slti t0, zero, -13
sw t0, 4(a0)
slti t0, zero, 13
sw t0, 8(a0)
# SLTIU
li t1, -50
sltiu t0, t1, 10
sw t0, 12(a0)
sltiu t0, t1, -100
sw t0, 16(a0)
# XORI
xori t0, t1, 682
sw t0, 20(a0)
# ORI
ori t0, t0, 883
sw t0, 24(a0)
# ANDI
andi t0, t0, 555
sw t0, 28(a0)
# SLLI
slli t0, t0, 5
sw t0, 32(a0)
slli t0, t0, 10
sw t0, 36(a0)
# SRLI
srli t0, t1, 8
sw t0, 40(a0)
srli t0, t1, 10
sw t0, 44(a0)
# SRAI
li t1, 0xcafe1234
srai t0, t1 10
sw t0, 48(a0)
srai t0, t0, 5
sw t0, 52(a0)