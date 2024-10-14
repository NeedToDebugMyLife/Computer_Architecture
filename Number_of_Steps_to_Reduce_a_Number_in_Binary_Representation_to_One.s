.data
data1:  .byte   0b10111001
data2:  .byte   0b1101
data3:  .byte   0b10
data4:  .byte   0b1

ans1:   .word   12
ans2:   .word   6
ans3:   .word   1
ans4:   .word   0

msg1:   .string "Test 1: "
msg2:   .string "Test 2: "
msg3:   .string "Test 3: "
msg4:   .string "Test 4: "

msg5:   .string "Result correct!\n"
msg6:   .string "Result wrong!\n"



.text
main:
    li      a7,     4

test1:
    la      a0,     msg1
    ecall
    
    la      t0,     data1
    lbu     s0,     0(t0)
    la      t0,     ans1
    lw      s1,     0(t0)

    jal     ra,     reduce2one

    bne     s1,     s5,       wrong
    la      a0,     msg5
    ecall

test2:
    la      a0,     msg2
    ecall
    
    la      t0,     data2
    lbu     s0,     0(t0)
    la      t0,     ans2
    lw      s1,     0(t0)

    jal     ra,     reduce2one

    bne     s1,     s5,       wrong
    la      a0,     msg5
    ecall

test3:
    la      a0,     msg3
    ecall
    
    la      t0,     data3
    lbu     s0,     0(t0)
    la      t0,     ans3
    lw      s1,     0(t0)

    jal     ra,     reduce2one

    bne     s1,     s5,       wrong
    la      a0,     msg5
    ecall

test4:
    la      a0,     msg4
    ecall
    
    la      t0,     data4
    lbu     s0,     0(t0)
    la      t0,     ans4
    lw      s1,     0(t0)

    jal     ra,     reduce2one

    bne     s1,     s5,       wrong
    la      a0,     msg5
    ecall

    li      a7,     10
    ecall
    ret

wrong:
    la      a0,     msg6
    ecall

    li      a7,     10
    ecall
    ret



reduce2one:
    li      s5,     0                       # steps
    li      s6,     0                       # times
    li      s7,     0                       # i

    li      t1,     32                      # 32
    li      t2,     31                      # 31
    li      t3,     1                       # 1

    mv      s8,     s0                      # s8 = num

    addi    sp,     sp,     -4
    sw      ra,     0(sp)

    jal     ra,     my_clz

    beq     s4,     t1,     reduce2one_0
    beq     s4,     t2,     reduce2one_1

    xori    s4,     s4,     -1
    addi    s4,     s4,     1
    addi    s6,     s4,     32              # times = 32 - count;

reduce2one_Loop:
    bge     s7,     s6,     reduce2one_end  # times <= i -> break;

    beq     t3,     s8,     reduce2one_end

    andi    t4,     s8,     0x1             # check bits
    beq     t4,     zero,   reduce2one_bit0

reduce2one_bit1:
    addi    s5,     s5,     2               # step+=2
    addi    s8,     s8,     1               # num++
    j       reduce2one_branch1

reduce2one_bit0:
    addi    s5,     s5,     1               # step++

reduce2one_branch1:
    srli    s8,     s8,     1               # num >> 1

    mv      t5,     s7
    addi    t5,     t5,     1
    
    bne     t5,     s6,     reduce2one_branch2
    beq     s8,     t3,     reduce2one_branch2

    li      s7,     0                       # i = 0
    jal     ra,     my_clz

    xori    s4,     s4,     0xFFFFFFFF
    addi    s4,     s4,     1     
    addi    s6,     s4,     32              # times = 32 - count;

reduce2one_branch2:
    addi    s7,     s7,     1
    j       reduce2one_Loop

reduce2one_0:
    li      s5,     -1
    j       reduce2one_end

reduce2one_1:
    li      s5,     0
    j       reduce2one_end

reduce2one_end: 
    lw      ra,     0(sp)
    addi    sp,     sp,     4
    ret



my_clz: 
    li      s2,     31      # i
    li      s3,     1       # 1
    li      s4,     0       # count

my_clz_loop:
    blt     s2,     zero,   my_clz_end
    sll     t0,     s3,     s2
    and     t0,     s0,     t0
    beq     t0,     zero,   result_0
    j       my_clz_end

result_0:
    addi    s4,     s4,     1           # count++
    addi    s2,     s2,     -1          # i--
    j       my_clz_loop
    
my_clz_end:
    ret
