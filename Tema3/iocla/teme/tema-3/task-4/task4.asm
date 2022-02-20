section .text

global expression
global term
global factor


section .text
        extern strcpy
        extern atoi
        extern strlen

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        
        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp

        xor esi, esi
        ; loop to find factors of multiply
loopTerm:
        xor ecx, ecx
        mov ecx, [ebx + esi]

        cmp cl, '*'
        je trueMultiply

        add esi, 1
        cmp esi, edx
        jl loopTerm

trueMultiply: ; factors are found

        ; Convert first number from string to int
        xor ebx, ebx
        mov ebx, [ebp + 8]
        mov byte [ebx + esi], '\0'
        push ebx
        call atoi
        push eax
        add esi, 1

        ; call term to evaluate next term
        xor edx, edx
        mov edx, [ebp + 12]
        mov [edx], esi
        xor eax, eax
        push dword [ebp + 12]
        push dword [ebp + 8]
        call term
        add esp, 8
        xor edx, edx
        pop edx

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp
        
        mov ebx, [ebp + 8] ;; s
        mov edx, [ebp + 12]
        mov edi, [edx] ;; value from pointer i ( *i)
        xor esi, esi
        ;; calculate len of string
        xor edx, edx
        mov edx, [ebp + 8]
        push edx
        call strlen
        add esp, 4

        xor edx, edx
        mov edx, eax
        xor eax, eax
        xor edi, edi
loopThroughExpression:
        xor ecx, ecx
        mov ecx, [ebx + esi]

        cmp cl, '+'
        je plus

        cmp cl, '*'
        je multiply

        add esi, 1
        cmp esi, edx
        jl loopThroughExpression

        jmp noOperantsLeft

plus: ; add number, result is stored in eax
        ; convert first number from string to int
        mov byte [ebx + esi], '\0'
        push ebx
        call atoi
        add esp, 4
        add esi, 1
        xor edx, edx

        mov edx, [ebp + 12]
        mov [edx], esi
        xor edx, edx
        xor ecx, ecx
        mov ecx, [ebx + esi]

        ; check whether the string ends
        cmp cl, '\0' 
        je end

        ; prepare to contiue evaluating the expression
        xor edx, edx
        mov edx, ebx
        add edx, esi
        add edi, eax
        xor eax, eax
        push edi
        push dword [ebp + 12]
        push edx
        call expression
        add esp, 8

        ; recursive calls end
        xor edi, edi
        pop edi
        add edi, eax
        xor eax, eax
        mov eax, edi
        jmp end

noOperantsLeft: ; no operants left
        xor eax, eax
        push ebx
        call atoi
        add esp, 4
        add edi, eax
        xor eax, eax
        mov eax, edi
        jmp end

multiply:
        ; we have multiply factors
        push edx
        push edi
        push esi
        push dword [ebp + 12]
        push dword [ebp + 8]
        call term
        add esp, 8
        pop esi
        pop edi
        pop edx
        jmp end

end:
        leave
        ret
