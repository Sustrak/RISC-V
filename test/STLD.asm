.text

.globl main
main:
	li a0, 0x1000
	
	li t0, 0xFFFF0000
	li t1, 0xAA00
	li t2, 0xAA
	
	sw t0, 0(a0)
	sh t1, 0(a0)
	lw t3, 0(a0)
	sw t3, 4(a0)
	sb t2, 4(a0)
	
	sw zero, 8(a0)
	lhu t2, 4(a0)
	lbu t1, 4(a0)
	
	addi t2, t2, 0x100
	addi t1, t1, 0x1
	
	sh t2, 8(a0)
	sb t1, 8(a0)