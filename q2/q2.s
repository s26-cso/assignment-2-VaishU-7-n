.section .rodata
fmt:   
.string "%d "
fmt2:
.string "%d\n"

.section .bss
arr:    .space 800
ans:    .space 800
stack:  .space 800     # stack of indices

.section .text
.globl main

main:
    addi sp, sp, -32
    sd ra, 24(sp)

    mv s0, a0        # argc
    mv s1, a1        # argv

    addi s0, s0, -1  # n
    li s2, 0         # i

convert_loop:
    bge s2,s0,nge
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
    addi s2,s0,-1       # i = n - 1 (Right to Left)
    li s3,-1            # top of stack = -1

    li t0,0             # i

initialize:
    bge t0,s0,loop
    la t1,ans
    slli t2,t0,2
    add t1,t1,t2
    li t3, -1               
    sw t3,0(t1)
    addi t0,t0,1
    j initialize

loop:
     blt s2,zero,done

while:
    blt s3, zero, assign
    la t0,stack
    slli t1,s3,2
    add t0,t0,t1
    lw t2,0(t0)             # t2 = stack.top()

    la t3,arr
    slli t4, s2, 2
    add t3, t3, t4
    lw t5, 0(t3)            # t5 = arr[i]

    la t6, arr
    slli t1, t2, 2
    add t6, t6, t1
    lw t6, 0(t6)            # t6 = arr[stack.top()]

    blt t5, t6, assign      # arr[stack.top()] > arr[i], stop popping
    addi s3, s3, -1         # pop
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