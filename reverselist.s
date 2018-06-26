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

.global _start
_test:
    movl         %esi,      (%rdi)
    movl         %edx,      4(%rdi)
    movl         (%rdi),    %eax
    addl         4(%rdi),   %eax
    ret

_start:
    subq         $8,        %rsp
    leaq         (%rsp),    %rdi
    movq         $30,        %rsi
    movq         $40,        %rdx
    call         _test 
    movq         %rax,      %rbx
    addq         $8,        %rsp
    movq         $1,        %rax
    int          $0x80
     
