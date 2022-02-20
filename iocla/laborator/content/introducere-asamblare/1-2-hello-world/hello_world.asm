%include "../io.mac"

section .data
    myString: db "Hello, World!", 0
    goodbye: db "Goodbye World!", 0

section .text
    global main
    extern printf

main:
    mov ecx, 6                      ; N = valoarea registrului ecx
    mov eax, 2
    mov ebx, 1
while:
    cmp ecx, ebx
    sub ecx, ebx
    jg printHello
    je printHello                        ; TODO1: eax > ebx?
    jmp printGoodbye

printHello:
    PRINTF32 `%s\n\x0`, myString
    jmp while                           ; TODO2.2: afisati "Hello, World!" de N ori
                                    ; TODO2.1: afisati "Goodbye, World!"
printGoodbye:
    PRINTF32 `%s\n\x0`, goodbye
    ret
