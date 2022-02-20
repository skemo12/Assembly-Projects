global get_words
global compare_func
global sort

section .data
    delim: dw ' ,.!?:'

section .text
    extern strtok
    extern strlen
    extern strcmp
    extern qsort
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    mov ebx, [ebp + 8] ;; words
    mov ecx, [ebp + 12] ;; number of words
    mov edx, [ebp + 16] ;; size

    ;; push qsort parameters
    push compare_func 
    push edx
    push ecx
    push ebx
    call qsort ; call qsort
    add esp, 16 ; restore stack

    leave
    ret

;; compare_func(char *s1, char *s2)
compare_func: ; custom compare function by length
    enter 0,0

    ; save register from previous function
    push ebx
    push ecx
    push edx
    push edi
    push esi

    xor ebx, ebx
    xor ecx, ecx
    mov ebx, [ebp + 8] ;; pointer s1

    xor eax, eax
    mov eax, [ebx] ; take string from pointer s1


    ; move values because we need eax and edx
    xor ebx, ebx
    mov ebx, eax ; move string s1

    ; len of str 1
    xor edx, edx
    xor eax, eax
    push ebx ; push string s1
    call strlen 
    add esp, 4

    xor edi, edi
    mov edi, eax ; edi equals strlen(s1)

    ; Calculate len of string s2
    xor eax, eax
    mov ecx, [ebp + 12] ;; pointer s2
    mov eax, [ecx]
    mov ecx, eax
    xor eax, eax

    push ecx
    call strlen
    add esp, 4

    xor edx, edx
    mov edx, edi ; edx equals strlen(string s2)

    ; Compare lengths
    cmp eax, edx 
    jl lower

    cmp eax, edx
    jg greater

    cmp eax, edx
    je equal

lower: ; if lower return bigger value
    mov eax, 1
    jmp endCompare

greater: ; if greater return smaller value
    mov eax, 0
    jmp endCompare

equal: ; if equal return strcmp value

    xor ebx, ebx
    xor ecx, ecx
    mov ebx, [ebp + 8] ;; pointer s1
    mov ecx, [ebp + 12] ;; pointer s2

    xor edi, edi
    mov edi, [ebx] ;; string s1
    xor edx, edx
    mov edx, [ecx] ;; string s2

    xor eax, eax
    push edx
    push edi
    call strcmp
    add esp, 8
    ; eax now has strcmp return value
    jmp endCompare

endCompare:

    ; restore registers
    pop esi
    pop edi
    pop edx
    pop ecx
    pop ebx

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov ebx, [ebp + 8] ;; s

    ; Calculate len of 
    push ebx
    call strlen
    add esp, 4
    mov edi, eax

    ; We use strtok to split into tokens, delim is defined in .data
    xor eax, eax
    push delim
    push ebx
    call strtok
    add esp, 8

    xor esi, esi
    xor edi, edi
    ; split in all tokens
strtokLoop:
    cmp eax, 0 ; check whether string is done
    jne move
    jmp endGetWords

continueLoop:
    xor eax, eax
    push delim
    push 0
    call strtok
    add esp, 8

    jmp strtokLoop

move: ; move token in words
    mov ecx, [ebp + 12] ; words 
    mov [ecx + 4 * esi], eax ;; move token in words[i] 

    ; continue loop
    add esi, 1
    jmp continueLoop

endGetWords:
    leave
    ret
