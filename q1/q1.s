
.global make_node
.globl insert
.globl get
.globl getAtMost
.section .text


make_node:

addi sp,sp,-16
sd ra,8(sp)

mv t1,a0    #storing x

li a0,24       #size of struct is 24
call malloc

mv t0,a0    #pointer to struct

sw t1,0(t0)

li t1,0
sd t1,8(t0)         #storing null for pointer left
sd t1,16(t0)        #storing null for pointer right

mv a0, t0

ld ra, 8(sp)
addi sp, sp, 16
ret


insert:

    addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    sd s1, 0(sp)

    mv s0, a0          # s0 = root
    mv s1, a1          # s1 = val

    bnez s0,m
    mv a0,s1
    call make_node
    j return_node

m:

    lw t0,0(s0)         #storing value of root->val

    blt s1, t0, move_left

move_right:

        ld t1, 16(s0)
        mv a0, t1        #for passing first arg as root->right
        mv a1, s1
        call insert
        sd a0,16(s0)        #root->right=insert(root->right,val)
        j done

move_left:

        ld t1, 8(s0)
        mv a0, t1        #for passing first arg as root->left
        mv a1, s1
        call insert
        sd a0,8(s0)      #root->left=insert(root->left,val)
        j done
  

done:
    mv a0, s0          # return root

return_node:
    ld ra, 16(sp)
    ld s0, 8(sp)
    ld s1, 0(sp)
    addi sp,sp,24
    ret



get:

 addi sp, sp, -24
    sd ra, 16(sp)
    sd s0, 8(sp)
    sd s1, 0(sp)

    mv s0, a0          # s0 = root
    mv s1, a1          # s1 = val

    beqz s0,not_found

    lw t0,0(s0)
    beq t0,s1,found

    blt s1, t0, move_left1

move_right1:

        ld t1, 16(s0)
        mv a0, t1        #for passing first arg as root->right
        mv a1, s1
        call get
        j return_node1

move_left1:

        ld t1, 8(s0)
        mv a0, t1        #for passing first arg as root->left
        mv a1, s1
        call get
        j return_node1


found:
    mv a0, s0
    j return_node1

not_found:
    li a0, 0

return_node1:
    ld ra, 16(sp)
    ld s0, 8(sp)
    ld s1, 0(sp)
    addi sp,sp,24
    ret

getAtMost:

addi sp,sp,-24
sd ra,16(sp)
sd s0,8(sp)
sd s1,0(sp)

mv s0,a0    #val
mv s1,a1    #root

li t0,-1   #ans

loop:

beqz s1,return_getAtmost    #if root == null end loop

lw t1,0(s1)     #root->val
beq t1,s0,return_val        #if root->val == val return val

blt t1,s0,move_r            #if root->val<right move right

move_l:
ld s1,8(s1)
j loop

move_r:
mv t0,t1
ld s1,16(s1)

j loop


return_val:
mv a0,s0
j done

return_getAtmost:
ld ra,16(sp)
ld s0,8(sp)
ld s1,0(sp)
addi sp,sp,24
mv a0,t0
ret


