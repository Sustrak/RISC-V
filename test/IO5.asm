li a0, 0x08200010
li a1, 0x08200040
li a2, 0x08200050
la a3, FI
la a4, bucle

bucle:
lw t0, 0(a0)
bnez t0, B0
li t2, 0xFFFFFFF
sw t2, 0(a1)
sw t2, 0(a2)
j a3
B0:
li t1, 1
bgt t0, t1, B1
li t2, 0xFFFFF80
sw t2, 0(a1)
sw t2, 0(a2) 
j a3
B1:
li t1, 2
bgt t0, t1, B2
li t2, 0xFFFC000
sw t2, 0(a1)
sw t2, 0(a2) 
j a3
B2:
li t1, 3
bge t0, t1, B3
li t2, 0xFE00000
sw t2, 0(a1)
sw t2, 0(a2) 
j a3
B3:
li t1, 4
bge t0, t1, FI
sw zero, 0(a1)
sw zero, 0(a2) 
FI:
j a4