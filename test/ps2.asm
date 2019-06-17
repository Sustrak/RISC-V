li a0, 0x08200060
li a1, 0x04000000
la a2, bucle

sw zero, 0(a1)

bucle:
	lb t3, 0(a0)
	sb t3, 0(a1)
	j a2
	