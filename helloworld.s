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
.global _start
_factorial:
    subq $4, %rsp    #栈指针下移4字节
    movl $1, (%rsp)  #ret初始化为1  #注意不能用movq,因为rsp只移动了4字节
    jmp .TEST
.LOOP:
    movl (%rsp), %eax
    imulq %rdi, %rax
    movl %eax, (%rsp)   # ret = ret * v
    subq  $1,  %rdi     # v  -= 1
.TEST:
    cmpq  $1,  %rdi     # 判断 v >= 1
    jg    .LOOP

    movl (%rsp), %eax  #设置返回值寄存器值为ret
    addq $4, %rsp
    ret

_start:
    movq $6, %rdi
    call _factorial
    movq %rax, %rbx
    movq $1,   %rax
    int  $0x80

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
# _decimalsum:
#     movq $0, %rax
# .LOOP:


    
