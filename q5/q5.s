.section .data
filename: .string "input.txt"
mode:     .string "r"
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
    la a0, filename    #first argument
    la a1, mode        #second argument
    call fopen
    mv s0, a0          # file pointer stored in s0

    beqz s0, finish

    mv a0, s0
    la a1, fmt2
    la a2, buffer
    
    mv a0,s0
    li a1,0     #zero to move forward
    li a2,2     #to move to end of file
    call fseek

    mv a0,s0
    call ftell
    mv s1,a0        #move to end of file to get size

    addi t1,s1,-1

    mv a0, s0
    mv a1,t1
    li a2,0
    call fseek

    mv a0,s0
    call fgetc
    li t4, 10
    bne a0, t4, skip_nl

    addi t1, t1, -1

skip_nl:
    li t2, 0

check:

    bge t2, t1, end1
    mv a0, s0
    mv a1, t2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t3, a0 

    mv a0, s0
    mv a1, t1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t4, a0 

    bne t3, t4, finish

    addi t2, t2, 1
    addi t1, t1, -1
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

