.section .data
filename: .string "input.txt"
mode:     .string "r"
fmt2:     .string "%s"

yes: .string "Yes\n"
no:  .string "No\n"

.section .text
.globl main

main:
    addi sp, sp, -32
    sd ra, 24(sp)

    # fopen(filename, "r")
    la a0, filename
    la a1, mode
    call fopen
    mv s0, a0

    beqz s0, print_no   # file open failed

    # go to end
    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    # get size
    mv a0, s0
    call ftell
    mv s1, a0

    addi t1, s1, -1   # last index

    # check if last char is newline
    mv a0, s0
    mv a1, t1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    li t4, 10
    bne a0, t4, skip_nl

    addi t1, t1, -1   # ignore newline

skip_nl:
    li t2, 0          # start index

check:
    bge t2, t1, print_yes

    # get char at start (t2)
    mv a0, s0
    mv a1, t2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t3, a0

    # get char at end (t1)
    mv a0, s0
    mv a1, t1
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t4, a0

    bne t3, t4, print_no

    addi t2, t2, 1
    addi t1, t1, -1
    j check

print_yes:
    la a0, fmt2
    la a1, yes
    call printf
    j cleanup

print_no:
    la a0, fmt2
    la a1, no
    call printf

cleanup:
    mv a0, s0
    call fclose

    ld ra, 24(sp)
    addi sp, sp, 32
    ret
