.text

li a0 0x08000010
li a1 0x08000000
bucle:
lw t0 0(a1)
sw t0 0(a0)
b bucle
