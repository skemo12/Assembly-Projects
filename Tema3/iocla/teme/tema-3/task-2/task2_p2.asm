section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; equivalent to <=> enter 0, 0
	push ebp
	push esp
	xor ebp, ebp
	pop ebp


	pop ecx ;; pop old ebp
	pop edx	;; pop eip
	pop eax ;; we get len
	pop ebx ;; we get str

	; restore stack
	push ebx ; push str
	push eax ; push len
	push edx ; push eip
	push ecx ; push ebp

	xor ecx, ecx
	xor edi, edi
	; Idea, we use edi as a verify method
	; For each openBracket we add 1, for each closeBracket we sub 1
	; At end we should have edi == 0

verifyStrLoop: ; verify string
	push dword [ebx + ecx] ; get curr char
	xor edx, edx
	pop edx ; curr char in edx
	cmp dl, '(' ; check for openBracket
	je openBracket
	cmp dl, ')' ; check for closeBracket
	je closeBracket

continueLoop:
	add ecx, 1 ; increment iterator
	cmp ecx, eax
	jl verifyStrLoop
	jmp verify

openBracket:
	add edi, 1
	jmp continueLoop

closeBracket:
	sub edi, 1
	cmp edi, 0
	jl verify
	jmp continueLoop

verify: ; check whether str is correct
	cmp edi, 0
	je true
	xor eax, eax ; asume str is incorrect
	jmp end

true: ; if str is correct, put 1 return value in eax
	push dword 1
	pop eax

end:
	; equivalent to leave
	push ebp
	pop esp
	pop ebp
	ret
