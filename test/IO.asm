.text

li a0 0x08200000
li a1 0x08200030
bucle:
lw t0 0(a1)
sw t0 0(a0)
b bucle