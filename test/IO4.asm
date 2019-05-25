.text

li a0 0x08000010
addi t0 zero 0
bucle:
addi t0 t0 1
li t1 10000
wait:
addi t1 t1 -1
bnez t1 wait
sw t0 0(a0)
b bucle
