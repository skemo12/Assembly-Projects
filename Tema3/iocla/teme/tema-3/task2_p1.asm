section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	; equivalent to <=> enter 0, 0
	push ebp
	push esp
	xor ebp, ebp
	pop ebp

	; ger parameters
	pop ecx ; pop old ebp
	pop ebx ; pop eip
	pop eax ; we get a parameter
	pop edx ; we get b parameter

	; restore stack
	push edx ; push a
	push eax ; push b
	push ebx ; push eip
	push ecx ;; push old ebp

	xor ebx, ebx
	xor ecx, ecx

	; We use Euclid algorithm with -
	push eax
	push edx

	pop ebx
	pop ecx

	cmp eax, edx
	jne compareAandBLoop

	jmp equals
compareAandBLoop:
	cmp eax, edx
	jg greater

	cmp eax, edx
	jl lower

	cmp eax, edx
	jne compareAandBLoop

	jmp equals

greater: ; if a > b
	sub eax, edx
	jmp compareAandBLoop

lower: ; if b > a
	sub edx, eax
	jmp compareAandBLoop

equals: ; end of loop, a == b == biggest divisor for both a and b
	; we calculate smallest multiple <=> initialA * initialB / cmmdc
	push edx
	push ebx
	pop eax
	
	mul ecx
	xor ecx, ecx
	pop ecx
	xor edx, edx
	div ecx
	
end: ; restore the stack <=> leave
	push ebp
	pop esp
	pop ebp

	ret
