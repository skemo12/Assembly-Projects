section .data
    num dd 13456198
    afis db "%d", 10, 0

section .text
global main
extern printf
extern puts

main:
    push ebp
    mov ebp, esp
push afis
call puts
add esp, 4
  
    xor eax, eax
    leave
    ret
