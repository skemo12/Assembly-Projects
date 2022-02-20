%include "../utils/printf32.asm"

section .data
    num dd 100
    num2 dd 0
    print_format1 db "Sum(", 0
    print_format2 db "): ", 0

section .text
extern printf
global main
main:
    push ebp
    mov ebp, esp

    mov ecx, [num2]     ; Use ecx as counter for computing the sum.
    xor ebx, ebx
    xor eax, eax       ; Use eax to store the sum. Start from 0.

add_help:
    add ebx, eax
    add ecx, 1
    xor eax, eax
    xor edx, edx
    jmp add_to_sum

add_to_sum:
    mov al, byte [num2]
    mov bl, byte [num2]
    mul bl
    mov edx, num
    cmp edx, [eax]
    jl add_help




    mov ecx, [num]
    PRINTF32 `%s\x0`, print_format1
    PRINTF32 `%u\x0`, ecx
    PRINTF32 `%s\x0`, print_format2
    PRINTF32 `%u\n\x0`, ebx

    leave
    ret
