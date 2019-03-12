.text

.globl main
main:
	lui t0, 0x1234
	lui t1, 0x5678
	lui t2, 0x9ABC
	lui s3, 0x10010
	sw t0, 0(s3)
	sw t1, 4(s3)
	sw t2, 8(s3)
	lw s0, 0(s3)
	lw s1, 4(s3)
	lw a0, 8(s3)
