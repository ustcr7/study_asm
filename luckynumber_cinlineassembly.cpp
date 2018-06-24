//_binaryonecount 和  _decimalsum 两个函数的代码上下换下位置就编译不过了....
extern "C"{
int mydiv(int v)
{
    __asm__(
        "_mydiv:"
        "    movq $0, %rdx;"
        "    movq %rdi, %rax;"
        "    movq %rsi, %rbx;"
        "    idivq %rbx;"
        "    ret;"
    );
}
int mymod(int v)
{
    __asm__(
        "    movq $0, %rdx;"
        "    movq %rdi, %rax;"
        "    movq %rsi, %rbx;"
        "    idivq %rbx;"
        "    movq %rdx, %rax;"
        "    ret;"
    );
}

int binaryonecount(int v)
{
    __asm__(
        "    subq $16,        %rsp;"
        "    movq $0,         (%rsp);"
        "    movq $0,         8(%rsp);"
        "    jmp  .TEST;"
        ".LOOP:"
        "    movq $1,         %rax;"
        "    movq  8(%rsp),   %rcx;"
        "    salq  %cl,     %rax;"
        "    andq  %rdi,       %rax;"
        "    je   .INCINDEX;"
        "    add  $1,         (%rsp);"
        ".INCINDEX:"
        "    add  $1,        8(%rsp);"
        ".TEST:"
        "    cmp $32,        8(%rsp);"
        "    jl  .LOOP;"
        "    movq (%rsp),      %rax;"
        "    addq $16,        %rsp;"
        "    ret;"
    );
}
int decimalsum(int v)
{
    __asm__(
        "    subq $16, %rsp;"
        "    movq $0, (%rsp);"
        "    movq %rdi, 8(%rsp);"
        "    movq $0, %rax;"
        "    jmp .TEST1;"
        ".LOOP1:"
        "    movq 8(%rsp), %rdi;"
        "    movq $10,      %rsi;"
        "    call mymod;"
        "    addq %rax,    (%rsp);"
        "    movq 8(%rsp), %rdi;"
        "    movq $10,      %rsi;"
        "    call mydiv;"
        "    movq %rax,    8(%rsp);"
        ".TEST1:"
        "    cmpq $0,      8(%rsp);"
        "    jg .LOOP1;"
        "    movq (%rsp), %rax;"
        "    addq $16, %rsp;"
        "    ret;"
    );
}
int luckynumbercount2(int v)
{
    __asm__(
        "    subq    $32,        %rsp;"
        "    movq    $0,         (%rsp);"
        "    movq    $1,         8(%rsp);"
        "    movq    %rdi,       16(%rsp);"
        "    jmp     .TEST3;"
        ".LOOP3:"
        "    movq   8(%rsp),     %rdi;"
        "    call   decimalsum;"
        "    movq   %rax,       24(%rsp);"
        "    movq   8(%rsp),     %rdi;"
        "    call   binaryonecount;"
        "    cmp    %rax,       24(%rsp);"
        "    jne    .INCINDEX3;"
        "    addq   $1,         (%rsp);"
        ".INCINDEX3:"
        "    addq    $1,         8(%rsp);"
        ".TEST3:"
        "    movq    16(%rsp),   %rcx;"
        "    cmp     %rcx,       8(%rsp);"
        "    jle     .LOOP3;"
        "    movq    (%rsp),     %rax;"
        "    addq    $32,        %rsp;"
        "    ret;"
    );
}

//FIX ME inline assambly中貌似不能用ret,如下的空函数都会导致core dump
int luckynumbercount(int v)
{
    __asm__(
        "    ret;"
    );
}
} //extern "C"

int main()
{
__asm("   movq  $1,       %rdi;");
__asm("   call  luckynumbercount;");
__asm("   movq  %rax,      %rbx;");
__asm("   movq  $1,        %rax;");
__asm("   int   $0x80;");
}
