.text
li a0 0x10010000
auipc t0 0
sw t0 0(a0)
auipc t0 0x1000
sw t0 4(a0)
# BEQ
beqz zero, LABEL1
li t0 1
b LABEL2
LABEL1:
li t0 2
LABEL2:
sw t0 8(a0)
# BGE
li t1, 5
bgez t1 LABEL3
li t0 1
b LABEL4
LABEL3:
li t0 2
LABEL4:
sw t0 12(a0)
# BGEU
li t1, -5
li t2, -6
bgeu t1 t2 LABEL5
li t0 1
b LABEL6
LABEL5:
li t0 2
LABEL6:
sw t0 16(a0)
# BLT
li t1, -5
bltz t1 LABEL7
li t0 1
b LABEL8
LABEL7:
li t0 2
LABEL8:
sw t0 20(a0)
# BNE
li t1, -5
li t2, -6
bne t1 t2 LABEL9
li t0 1
b LABEL10
LABEL9:
li t0 2
LABEL10:
sw t0 24(a0)
