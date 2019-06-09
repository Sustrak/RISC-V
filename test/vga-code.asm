li t0, 0x3FF # Blue
li t1, 0xFFC00 # Green
li t2, 0x3FF00000 # Red

li t3, 0 # X 0->640
li t4, 0 # Y 0->480
li t5, 640
li t6, 480

li a0, 0x08200000 # PIXEL BUFFER ADDR
li s5, 0x05000000

LOOP_Y:
bge t4, t6, LOOP_END_Y
slli a1, t4, 12         # BASE ADDRESS FOR THE LINE
or a1, a1, a0

li s1, 160
bge t4, s1, GREEN
mv s0, t0
beq zero, zero, LOOP_X
GREEN:
li s1, 320
bge t4, s1, RED
mv s0, t1
beq zero, zero, LOOP_X
RED:
mv s0, t2
LOOP_X:
bge t3, t5, LOOP_END_X
slli a2, t3, 2
or a2, a1, a2           # PIXEL ADDRESS

sw a2, 0(s5)
addi s5, s5, 4

sw s0, 0(a2)
addi t3, t3, 1
beq zero, zero, LOOP_X
LOOP_END_X:
addi t4, t4, 1
xor t3, t3, t3
beq zero, zero, LOOP_Y
LOOP_END_Y:
nop
beq zero, zero, LOOP_END_Y
