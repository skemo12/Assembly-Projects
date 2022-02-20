%include "../io.mac"

section .text
    global main
    extern printf

main:
    ;cele doua multimi se gasesc in eax si ebx
    mov eax, 139
    mov ebx, 169
    PRINTF32 `%u\n\x0`, eax ; afiseaza prima multime
    PRINTF32 `%u\n\x0`, ebx ; afiseaza cea de-a doua multime

    ; TODO1: reuniunea a doua multimi
    PRINTF32 `Reuniunea este: \x0`
    mov ecx, eax
    add ecx, ebx 
    PRINTF32 `%u\n\n\x0`, ecx

    ; TODO2: adaugarea unui element in multime
    PRINTF32 `Adaugarea este: \x0`
    mov ecx, eax
    or ecx, 257
    PRINTF32 `%u\n\n\x0`, ecx

    ; TODO3: intersectia a doua multimi
    PRINTF32 `Intersectia este: \x0`
    mov ecx, eax
    and ecx, ebx
    PRINTF32 `%u\n\n\x0`, ecx

    ; TODO4: complementul unei multimi
    PRINTF32 `Complementul este: \x0`
    mov ecx, eax
    not ecx
    PRINTF32 `%u\n\n\x0`, ecx


    ; TODO5: eliminarea unui element
    PRINTF32 `Eliminarea este: \x0`
    mov ecx, eax
    sub ecx, 1
    PRINTF32 `%u\n\n\x0`, ecx

    ; TODO6: diferenta de multimi EAX-EBX
    PRINTF32 `Diferenta este: \x0`
    mov ecx, eax
    sub ecx, ebx
    PRINTF32 `%u\n\n\x0`, ecx

    xor eax, eax
    ret
