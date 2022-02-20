section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov eax, [ebp + 8]  ; n
    mov ebx, [ebp + 12] ; struct node* node

	mov ecx, 1 ;; initiaze for looping from 1 to n
	xor edx, edx
	mov edx, -1 ;; checker for whether we have a head to list
	
	; Idea - numbers are consecutive so we create a loop from 1 to N
	; Find the address of node with each consecutive value and link them.
loopOneToN: ; loop from one to n, ecx is ith element
	cmp ecx, eax
	jg end

	xor esi, esi
loopElements: ; loop through list elements
	xor edi, edi
	mov edi, [ebx + esi * 8] ; edi has the value of ith node

	cmp ecx, edi
	je found 
	add esi, 1
	cmp esi, eax
	jl loopElements
	
found: ; founded the ith element

	cmp edx, -1 ; checker whether list has head setted
	je firstElement

	push eax ; save n for later
	xor eax, eax

	push edx ; save the index of ith node
	xor edx, edx
	mov dl, byte 8

	mov eax, esi
	mul edx ; multiply index by sizeof struct

	xor edx, edx
	pop edx

	xor edi, edi
	mov edi, ebx
	add edi, eax ; edi is now the address of node

	mov [ebx + edx * 8 + 4], edi ; ebx + edx * 8 + 4 == last element .nexy

	add ecx, 1
	xor eax, eax
	pop eax
	xor edx, edx
	mov edx, esi
	jmp loopOneToN

firstElement: ; set list head

	xor edx, edx
	mov edx, esi
	push edx
	add ecx, 1
	jmp loopOneToN ;; continue the loop


end: ; end of function, set return value

	xor edx, edx
	pop edx ; get list head offset
	
	xor eax, eax
	xor ecx, ecx
	mov ecx, edx
	xor edx, edx
	mov dl, byte 8 

	mov eax, ecx
	mul edx ;; multiply the index by the size of struct

	xor ecx, ecx
	mov ecx, eax

	xor eax, eax
	mov eax, ebx
	add eax, ecx ;; set return value
	
	leave
	ret
