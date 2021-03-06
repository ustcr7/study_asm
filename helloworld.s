# as -o helloworld.o helloworld.s
# ld -o helloworld helloworld.o
# # print hello world
# .data                    # 数据段声明
#         msg : .string "Hello, world!\\n" # 要输出的字符串
#         len = . - msg                   # 字串长度
# .text                    # 代码段声明
# .global _start           # 指定入口函数
#          
# _start:                  # 在屏幕上显示一个字符串
#         movl $len, %edx  # 参数三：字符串长度
#         movl $msg, %ecx  # 参数二：要显示的字符串
#         movl $1, %ebx    # 参数一：文件描述符(stdout) 
#         movl $4, %eax    # 系统调用号(sys_write) 
#         int  $0x80       # 调用内核功能
#          
#                          # 退出程序
#         movl $0,%ebx     # 参数一：退出代码
#         movl $1,%eax     # 系统调用号(sys_exit) 
#         int  $0x80       # 调用内核功能


# # test add
# .global _start
# 
# _add:
#     movq %rdi, %rax
#     addq %rsi, %rax
#     ret
# _start:
#     movq $3, %rdi
#     movq $4, %rsi
#     call _add
#     movq %rax, %rbx
#     movq $1, %rax
#     int  $0x80


# # test max
# .global _start
# 
# _max:
#     cmpq %rsi,  %rdi
#     jge .FIRSTISBIG
#     movq %rsi, %rax
#     jmp .RETURN
# .FIRSTISBIG:
#     movq %rdi, %rax
# .RETURN:
#     ret
# 
# _start:
#     movq $5,   %rdi
#     movq $4,   %rsi
#     call  _max
#     movq %rax, %rbx
#     movq $1,   %rax
#     int $0x80

# # 除法    f(a,b) -->  return a/b
# .global _start
# _mydiv:
#     movq  $27, %rax
#     movq  $3,  %rbx
#     idivq %rbx
#     ret
# _start:
#     movq $5,   %rdi
#     movq $4,   %rsi
#     call  _mydiv
#     movq %rax, %rbx
#     movq $1,   %rax
#     int $0x80

# # 取余数    f(a,b) -->  return a%b
# .global _start
# _mymod:
#     movq  $5,  %rax
#     movq  $3,   %rbx
#     idivq %rbx
#     movq  %rdx, %rax
#     ret
# _start:
#     call  _mymod
#     movq %rax, %rbx
#     movq $1,   %rax
#     int $0x80

# while循环  &  栈变量
# int factorial(int v)
# {
#     int ret = 1;
#     while(v>1)
#     {
#         ret = ret * v;
#         v -= 1;
#     }
#     return ret;
# }
#.global _start
#_factorial:
#    subq $8, %rsp    #栈指针下移4字节
#    movq $1, (%rsp)  #ret初始化为1  #注意不能用movq,因为rsp只移动了4字节
#    jmp .TEST
#.LOOP:
#    movq (%rsp), %rax
#    imulq %rdi, %rax
#    movq %rax, (%rsp)   # ret = ret * v
#    subq  $1,  %rdi     # v  -= 1
#.TEST:
#    cmpq  $1,  %rdi     # 判断 v >= 1
#    jg    .LOOP
#
#    movq (%rsp), %rax  #设置返回值寄存器值为ret
#    addq $8, %rsp
#    ret
#
#_start:
#    movq $3, %rdi
#    call _factorial
#    movq %rax, %rbx
#    movq $1,   %rax
#    int  $0x80

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
# .global _start
# _mydiv:
#     movq $0, %rdx    #有的说法是div指令被除数高16位在dx, 低16位在ax中
#     movq %rdi, %rax
#     movq %rsi, %rbx
#     idivq %rbx
#     ret
# _mymod:
#     movq $0, %rdx
#     movq %rdi, %rax
#     movq %rsi, %rbx
#     idivq %rbx
#     movq %rdx, %rax
#     ret
# 
# _decimalsum:
#     subq $16, %rsp
#     movq $0, (%rsp)      # sum初始化为0
#     movq %rdi, 8(%rsp)   # 初始化栈上临时变量值为v
#     movq $0, %rax  #无意义方便调试
#     jmp .TEST
# .LOOP:
#     movq 8(%rsp), %rdi 
#     movq $10,      %rsi
#     call _mymod
#     addq %rax,    (%rsp)
#     movq 8(%rsp), %rdi 
#     movq $10,      %rsi
#     call _mydiv
#     movq %rax,    8(%rsp) 
# .TEST:
#     cmpq $0,      8(%rsp)
#     jg .LOOP
#     
#     movq (%rsp), %rax
#     addq $16, %rsp
#     ret
# 
# _start:
#     movq $51303, %rdi
#     call _decimalsum
#     movq %rax, %rbx
#     movq $1,   %rax
#     int  $0x80


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

.global _start
_onecount:
    subq $16,        %rsp
    movq $0,         (%rsp)    # count = 0
    movq $0,         8(%rsp)   # i = 0;
    jmp  .TEST
.LOOP:
    movq $1,         %rax
    #salq  8(%rsp),    %rax   #FIXME 不知道怎么取i的低8位
    movq  8(%rsp),   %rcx
    salq  %cl,     %rax       #1<<i
    andq  %rdi,       %rax    # target & (1<<i)
    je   .INCINDEX
    add  $1,         (%rsp)   # count += 1

.INCINDEX:
    add  $1,        8(%rsp)   # i += 1
.TEST:
    cmp $32,        8(%rsp)
    jl  .LOOP

    movq (%rsp),      %rax
    addq $16,        %rsp
    ret

_start:
   movq  $11,       %rdi
   call _onecount
   movq  %rax,      %rbx
   movq  $1,        %rax
   int   $0x80
