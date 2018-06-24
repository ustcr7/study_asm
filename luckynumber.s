#    as -g -o luckynumber.o luckynumber.s
#    ld -o luckynumber luckynumber.o
# 疑问:a函数中使用了%rax, 但是调用b函数中%rax被破坏了咋办, 所有的寄存器都存在这样的问题吧,所以必须使用栈上变量?
# 求一个数的十进制表示,其各位相加之和 eg: f(504) = 5 + 0 + 1 = 9
# int decimal_sum(int v)
# {
#     int sum = 0;
#     while(v>0)
#     {
#       sum += (v%10);
#       v = v/10;
#     }
#     return sum;
# }
#
.global _start
_mydiv:
    movq $0, %rdx    #有的说法是div指令被除数高16位在dx, 低16位在ax中
    movq %rdi, %rax
    movq %rsi, %rbx
    idivq %rbx
    ret
_mymod:
    movq $0, %rdx
    movq %rdi, %rax
    movq %rsi, %rbx
    idivq %rbx
    movq %rdx, %rax
    ret

_decimalsum:
    subq $16, %rsp
    movq $0, (%rsp)      # sum初始化为0
    movq %rdi, 8(%rsp)   # 初始化栈上临时变量值为v
    movq $0, %rax  #无意义方便调试
    jmp .TEST1
.LOOP1:
    movq 8(%rsp), %rdi 
    movq $10,      %rsi
    call _mymod
    addq %rax,    (%rsp)
    movq 8(%rsp), %rdi 
    movq $10,      %rsi
    call _mydiv
    movq %rax,    8(%rsp) 
.TEST1:
    cmpq $0,      8(%rsp)
    jg .LOOP1
    
    movq (%rsp), %rax
    addq $16, %rsp
    ret

# 求一个正整数中二进制表示中1的个数, eg: 13  (1011) 1的个数为3
#int one_count(int target)
#{
#    int count = 0;
#    for(int i=0; i<32; ++i)
#    {
#        if(target & (1<<i))
#        {
#           count += 1;
#        }
#    }
#    return count;
#}

_binaryonecount:
    subq $16,        %rsp
    movq $0,         (%rsp)    # count = 0
    movq $0,         8(%rsp)   # i = 0;
    jmp  .TEST2
.LOOP2:
    movq $1,         %rax
    #salq  8(%rsp),    %rax   #FIXME 不知道怎么取i的低8位
    movq  8(%rsp),   %rcx
    salq  %cl,     %rax       #1<<i
    andq  %rdi,       %rax    # target & (1<<i)
    je   .INCINDEX2
    add  $1,         (%rsp)   # count += 1

.INCINDEX2:
    add  $1,        8(%rsp)   # i += 1
.TEST2:
    cmp $32,        8(%rsp)
    jl  .LOOP2

    movq (%rsp),      %rax
    addq $16,        %rsp
    ret

# int luck_number_count(int n)
# {
#     int count = 0;
#     for(int i=0; i<=n; ++i)
#     {
#         if(decimal_count(i) == onecount(i))
#         {
#             count += 1;
#         }
#     }
#     return count;
# }
_luckynumbercount:
    subq    $32,        %rsp
    movq    $0,         (%rsp)   # count
    movq    $1,         8(%rsp)   # i
    movq    %rdi,       16(%rsp)  # n
    jmp     .TEST3
.LOOP3:
    movq   8(%rsp),     %rdi
    call   _decimalsum
    movq   %rax,       24(%rsp)  # 十进制位数相加
    movq   8(%rsp),     %rdi
    call   _binaryonecount       # 二进制1个数
    cmp    %rax,       24(%rsp)
    jne    .INCINDEX3
    addq   $1,         (%rsp)

.INCINDEX3:
    addq    $1,         8(%rsp)    # i += 1
.TEST3:
    movq    16(%rsp),   %rcx      #cmp貌似不支持两个内存比较,所以必须放一个到寄存器
    cmp     %rcx,       8(%rsp)    # i < n
    jle     .LOOP3

    movq    (%rsp),     %rax
    addq    $32,        %rsp
    ret

_start:
   movq  $21,       %rdi
   call  _luckynumbercount
   movq  %rax,      %rbx
   movq  $1,        %rax
   int   $0x80

