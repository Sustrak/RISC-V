.text
li a0 0x00001000
li t0 10	# Number of iterations
li t1 0		# fnow
sw t1 0(a0)
addi a0 a0 4
li t2 1		# fnext
sw t2 0(a0)
addi a0 a0 4
WHILE:
beqz t0 END_WHILE
addi t0 t0 -1
add t3 t1 t2	# aux = fnow + fnext
mv t1 t2	# fnow = fnext
mv t2 t3	# fnext = aux
sw t1 0(a0)
addi a0 a0 4
b WHILE
END_WHILE:
b END_WHILE
