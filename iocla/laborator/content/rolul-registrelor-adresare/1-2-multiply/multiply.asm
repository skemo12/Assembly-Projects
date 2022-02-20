%include "../utils/printf32.asm"

; https://en.wikibooks.org/wiki/X86_Assembly/Arithmetic

section .data
    num1 db 10
    num2 db 6
    num1_w dw 1349
    num2_w dw 9949
    num1_d dd 134932
    num2_d dd 994912
    print_mesaj dd 'Rezultatul este: 0x', 0

section .text
extern printf
global main
main:
    push ebp
    mov ebp, esp

    ; Multiplication for db
    mov al, byte [num1]
    mov bl, byte [num2]
    mul bl
    
    ; Print result in hexa
    PRINTF32 `%s\x0`, print_mesaj
    xor ebx, ebx
    mov bx, ax
    PRINTF32 `%hx\n\x0`, eax


   ; TODO: Implement multiplication for dw and dd data types.

	; dw multiplication
    mov ax, word [num1_w]
    mov bx, word [num2_w]
	mul bx

    ; Print result in hexa
    PRINTF32 `%s\x0`, print_mesaj
    xor edx, edx
    mov bx, ax
    PRINTF32 `%hx\n\x0`, edx

	; dd 
	mov eax, dword [num1_d]
	mov ecx, dword [num2_d]
	mul ecx

	; Print result in hexa
    PRINTF32 `%s\x0`, print_mesaj
    xor ebx, ebx
    mov bx, ax
    PRINTF32 `%hx\n\x0`, edx

    leave
    ret
