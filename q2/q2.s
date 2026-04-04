.section .rodata
fmt:
.string "%d "
fmt2:
.string "%d\n"

.section .bss
arr:    .space 800
ans:    .space 800
stack:  .space 800

.section .text
.globl main

main:
    addi sp, sp, -32
    sd ra, 24(sp)

    mv s0, a0
    mv s1, a1

    addi s0, s0, -1
    li s2, 0

convert_loop:
    bge s2, s0, nge
    addi t0, s2, 1
    slli t0, t0, 3
    add t1, s1, t0
    ld a0, 0(t1)
    call atoi

    la t3, arr
    slli t4, s2, 2
    add t3, t3, t4
    sw a0, 0(t3)
    addi s2, s2, 1
    j convert_loop

nge:
    addi s2, s0, -1
    li s3, -1
    li t0, 0

initialize:
    bgt t0, s0, loop
    la t1, ans
    slli t2, t0, 2
    add t1, t1, t2
    li t3, -1
    sw t3, 0(t1)
    addi t0, t0, 1
    j initialize

loop:
    blt s2, zero, done

while:
    blt s3, zero, assign
    la t0, stack
    slli t1, s3, 2
    add t0, t0, t1
    lw t2, 0(t0)

    la t3, arr
    slli t4, s2, 2
    add t3, t3, t4
    lw t5, 0(t3)

    la t6, arr
    slli t1, t2, 2
    add t6, t6, t1
    lw t6, 0(t6)

    blt t5, t6, assign
    addi s3, s3, -1
    j while

assign:
    la t3, ans
    slli t4, s2, 2
    add t3, t3, t4
    blt s3, zero, no_elem

    la t0, stack
    slli t1, s3, 2
    add t0, t0, t1
    lw t2, 0(t0)
    sw t2, 0(t3)
    j push

no_elem:
    li t2, -1
    sw t2, 0(t3)

push:
    addi s3, s3, 1
    la t0, stack
    slli t1, s3, 2
    add t0, t0, t1
    sw s2, 0(t0)
    addi s2, s2, -1
    j loop

done:
    li s2, 0

print:
    bge s2, s0, print_last
    la t0, ans
    slli t1, s2, 2
    add t0, t0, t1
    lw a1, 0(t0)
    la a0, fmt
    call printf
    addi s2, s2, 1
    j print

print_last:
    la t0, ans
    slli t1, s2, 2
    add t0, t0, t1
    lw a1, 0(t0)
    la a0, fmt2
    call printf

end:
    ld ra, 24(sp)
    addi sp, sp, 32
    li a0, 0
    ret
    