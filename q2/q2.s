.section .rodata
fmt:    
.string "%d "
fmt2:
.string "%d\n"

.section .text
.globl main

main:
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    
    mv s0, a0        # argc
    mv s1, a1        # argv

    addi s0, s0, -1  # n(here length of arr = argc(total args)-1 as first arg is file name)
    blez s0, done_print 

  
    slli a0, s0, 2    # a0 = n * 4 bytes
    call malloc       # Allocate space for 'arr'
    mv s4, a0         # s4 stores base address of arr

    slli a0, s0, 2    # a0 = n * 4 bytes
    call malloc       # Allocate space for 'ans'
    mv s5, a0         # s5 stores base address of ans

    slli a0, s0, 2    # a0 = n * 4 bytes
    call malloc       # Allocate space for 'stack'
    mv s6, a0         # s6 stores base address of stack
   

    li s2, 0         # i

convert_loop:
    bge s2,s0,nge
    addi t0, s2, 1      #(in offset t0 should be 1 greater than s2 to match arg list and arr indexing)
    slli t0, t0, 3      #t0 = 8 (offset calc)
    add t1, s1, t0      # t1 = s1(base)+t0(offset) so t1 is = a[i] memory
    ld a0, 0(t1)        
    call atoi           #calling atoi to convert string to int as cli are strings

    mv t3, s4           # t3 contains base value of dynamic arr (malloced s4)
    slli t4, s2, 2      #offset calc t4 = s2*4
    add t3, t3, t4
    sw a0, 0(t3)        #storing converted integer value
    addi s2, s2, 1      #i++
    j convert_loop

nge:
    addi s2,s0,-1       # i = n - 1 (Right to Left)
    li s3,-1            #top of stack = -1

    li t0,0             #i

initialize:
    bge t0,s0,loop         #if i>=n exit curr loop
    mv t1, s5               #t1 stores adress of dynamic ans (malloced s5)
    slli t2,t0,2            # offset calc t2 = i*4
    add t1,t1,t2            #t1=adress+offset
    li t3, -1               
    sw t3,0(t1)             # ans[i]=-1
    addi t0,t0,1            #i++
    j initialize

loop:
     blt s2,zero,done

while:

    blt s3, zero, assign       #if stack.top()==0 push element into stack
    mv t0, s6               # t0 stores address of dynamic stack (malloced s6)
    slli t1,s3,2            #offset calc t1 = stack.top()*4
    add t0,t0,t1            #adress calc t0 = base add + offset
    lw t2,0(t0)             #t2 now contains value of stack top

    mv t3, s4               # use malloced arr (s4)
    slli t4, s2, 2
    add t3, t3, t4
    lw t5, 0(t3)        #t5 contains value of arr[i]

    #now we want arr[stack.top()]

    mv t6, s4               # use malloced arr (s4)
    slli t1, t2, 2
    add t6, t6, t1
    lw t6, 0(t6)       #t7 contains arr[stack.top()]

    blt t5, t6, assign      # If current < stack top, we found NGE
    addi s3, s3, -1         # pop
    j while


assign:
    mv t3, s5               # use malloced ans (s5)
    slli t4, s2, 2
    add t3, t3, t4
    blt s3, zero, no_elem

    # result[i] = stack[top]
    mv t0, s6               #  use malloced stack (s6)
    slli t1, s3, 2
    add t0, t0, t1
    lw t2, 0(t0)
    sw t2, 0(t3)
    j push

no_elem:
    li t2, -1
    sw t2, 0(t3)
    
  
push:
    addi s3, s3, 1      #incrementing tos
    mv t0, s6           #  use malloced stack (s6)
    slli t1, s3, 2
    add t0, t0, t1
    sw s2, 0(t0)        #storing i on top of stack

    addi s2, s2, -1
    j loop


done:
    li s2, 0
    addi s0,s0,-1
print:
    bge s2, s0, print_last
    mv t0, s5           # FIXED: use malloced ans (s5)
    slli t1, s2, 2
    add t0, t0, t1
    lw a1, 0(t0)
    la a0, fmt
    call printf
    addi s2, s2, 1
    j print

print_last:

    mv t0, s5           # use malloced ans (s5)
    slli t1, s2, 2
    add t0, t0, t1
    lw a1, 0(t0)
    la a0, fmt2
    call printf

done_print:             # Label for early exit if no args

end:
    # Restoring all registers from stack
    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    
    addi sp, sp, 64
    li a0, 0
    ret
    