.text

.globl main
main:
	li a0, 0xFFFFFFFF
	sw a0, 0(zero)
	sw a0, 8(zero)
	addi t0, zero, 0x001
	addi t1, zero, 0x700
	sb t0, 0(zero)
	sh t1, 8(zero)
	
