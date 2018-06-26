# https://www.nowcoder.com/practice/75e878df47f24fdc9dc3e400ec6058ca?tpId=13&&tqId=11168&rp=2&ru=/activity/oj&qru=/ta/coding-interviews/question-ranking
#    struct ListNode {
#        int val;
#        struct ListNode *next;
#        ListNode(int x) :
#                val(x), next(NULL) {
#        }
#    };
#    class Solution {
#    public:
#        ListNode* ReverseList(ListNode* pHead) {
#            ListNode *pre = NULL;
#            ListNode  *cur = pHead;
#            while(cur != NULL)
#            {
#                ListNode *tmp = cur->next;
#                cur->next = pre;
#                pre = cur;
#                cur = tmp;
#            }
#            return pre;
#        }
#    };


# 测试结构体
# struct Node
# {
#     int a;
#     int b;
# };
# int main()
# {
#     Node n;
#     n.a = 1;
#     n.b = 2;
#     return n.a + n.b;
# }
# .global _start
# _start:
#     subq         $8,        %rsp
#     movl         $1,        (%rsp)
#     movl         $2,        4(%rsp)
#     movq         $0,        %rax
#     addl         (%rsp),    %eax
#     addl         4(%rsp),   %eax
#     movq         %rax,      %rbx
#     addq         $8,        %rsp
#     movq         $1,        %rax
#     int          $0x80


# 测试结构体 & 指针
# struct Node
# {
#     int a;
#     int b;
# };
# int test(Node *node, int a, int b)
# {
#     n->a = a;
#     n->b = b;
#     return n->a + n->b;
# }
# int main()
# {
#     Node n;
#     return test(&n, 3, 4);
# }

# .global _start
# _test:
#     movl         %esi,      (%rdi)
#     movl         %edx,      4(%rdi)
#     movl         (%rdi),    %eax
#     addl         4(%rdi),   %eax
#     ret
# 
# _start:
#     subq         $8,        %rsp
#     leaq         (%rsp),    %rdi
#     movq         $30,        %rsi
#     movq         $40,        %rdx
#     call         _test 
#     movq         %rax,      %rbx
#     addq         $8,        %rsp
#     movq         $1,        %rax
#     int          $0x80
#

#    struct ListNode {
#        int val;
#        struct ListNode *next;
#        ListNode(int x) :
#                val(x), next(NULL) {
#        }
#    };
# ListNode* ReverseList(ListNode* pHead) {
#     ListNode *pre = NULL;
#     ListNode  *cur = pHead;
#     while(cur != NULL)
#     {
#         ListNode *tmp = cur->next;
#         cur->next = pre;
#         pre = cur;
#         cur = tmp;
#     }
#     return pre;
# }
# int main()
# {
#     ListNode n1;
#     ListNode n2;
#     ListNode n3;
#     n1.val = 10;
#     n2.val = 712;
#     n3.val = 55;
#     n1.next = &n2;
#     n2.next = &n3;
#     n3.next = NULL;
# 
#     ListNode *root = ReverseList(&n1);
# 
#     return root->val; //WCC TODO 调用系统调用printf 打印到终端方便观察
# }
_reverselist:
     subq        $24,        %rsp
     movq        $0,         (%rsp)     # pre = NULL
     movq        %rdi,       8(%rsp)    # cur = pHead
     jmp         .TEST
.LOOP:
     movq        12(%rsp)    , 16(%rsp)    # tmp = cur->next 
     movq        (%rsp),      12(%rsp)     # cur->next = pre
     movq        8(%rsp),       (%rsp)     # pre = cur
     movq        16(%rsp),      8(%rsp)    # cur = tmp
.TEST:
    cmp         $0,         8(%rsp)
    jne         .LOOP

    movq        (%rsp),     %rax           # return pre
    addq        $24,        %rsp
    ret

_start:
    subq        $44,         %rsp 
    movq        $10,         %(rsp)    # n1.val = 10
    movq        $712,        12%(rsp)  # n2.val = 712
    movq        $55,         55%(rsp)  # n3.val = 55
    movq        12%(rsp),    4%(rsp)   # n1.next = &n2
    movq        24(%rsp),    16(%rsp)  # n2.next = &n3
    movq        $0,          28(%rsp)  # n3.next = NULL
    movq        (%rsp),      %rdi
    call        _reverselist
    movq        %rax,        36(%rsp)
    movq        36(%rsp),    %rbx        # return root->val

    addq        $44,         %rsp 
    movq        $1,          %rax
    int         $0x80
