.text

.globl main
main:
	lui t0, 0x1234
	lui t1, 0x5678
	lui t2, 0x9ABC
	sw t0, 0(zero)
	sw t1, 4(zero)
	sw t2, 8(zero)
	lw s0, 0(zero)
	lw s1, 4(zero)
	lw a0, 8(zero)
