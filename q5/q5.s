.section .data
filename: .string "input.txt"
mode:     .string "r"
fmt:      .string "%d"
fmt2: .string "%s"
buffer :
.space 10004
yes:
.string "Yes\n"
no:
.string "No\n"

.section .text
.globl main


main:
    addi sp, sp, -32
    sd ra, 24(sp)

    # fopen(filename, "r")
    la a0, filename
    la a1, mode
    call fopen
    mv s0, a0         # FILE* stored in s0

    beqz s0, finish

    mv a0, s0
    la a1, fmt2
    la a2, buffer
    call fscanf
    la t0,buffer

    mv a0, s0
    call fclose
    li t1,0 #index offset
move_end:
add t2,t1,t0
lb t3,0(t2)
beq t3,x0,end
addi t1,t1,1
j move_end

end:
addi t1,t1,-1 #stores index of right most char
li t2,0 #stores index of leftmost char

check:

add t5,t0,t1
add t6,t0,t2
lb t3,0(t6)
lb t4,0(t5)

bge t2,t1,end1

bne t3,t4,finish

addi t2,t2,1
addi t1,t1,-1

j check

end1:

la a0,fmt2
la a1,yes
call printf
ld ra, 24(sp)
addi sp, sp, 32
ret


finish:

la a0,fmt2
la a1,no
call printf
ld ra, 24(sp)
addi sp, sp, 32
ret

