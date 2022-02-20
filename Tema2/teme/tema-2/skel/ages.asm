; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; TODO: Implement ages
    ;; FREESTYLE STARTS HERE

agesEntry:
    dec edx

loopThroughDates:

    ;; Make registries 0
    xor eax, eax
    xor ebx, ebx

    ;; We take person's birth day and present year
    mov eax, [edi + edx * my_date_size + my_date.year]
    mov ebx, [esi + my_date.year]
    
    ;; We see wether the person's age is 0
    cmp bx, ax
    jbe zeroAgesPerson

    ;; We calculate the age with the assumption that the person has not
    ;; Celebrated his birthday yet
    sub bx, ax
    dec bx
    push bx ;; We push person's age in stack to use it later

    ;; Check month difference from present and person's birth month
    xor ebx, ebx
    xor eax, eax
    mov ax, [edi + edx * my_date_size + my_date.month]
    mov bx, [esi + my_date.month]

    ;; If the diff is <, than we do not increment age; else we increment age
    ;; If months are equal, we check the date
    cmp bx, ax
    jb addDataInAllAges
    jg incrementAge

    ;; Check day difference from present and person's birth day
    xor ebx, ebx
    xor eax, eax
    mov ax, [edi + edx * my_date_size + my_date.day]
    mov bx, [esi + my_date.day]

    ;; If the diff id < than we do not increment age
    cmp bx, ax
    jb addDataInAllAges
    
    ;; Increment the age
incrementAge:
    xor ebx, ebx
    xor eax, eax
    pop bx
    inc bx
    push bx

    ;; We only enter zero age if the peron's age is 0
    jmp addDataInAllAges
zeroAgesPerson:
    xor ebx, ebx
    mov bx, 0
    push bx
    
    ;; We add the data into the ages array
addDataInAllAges:
    xor ebx, ebx
    pop bx
    mov [ecx + edx * 4], ebx
    

    ;; We continute the initial loop
    dec edx
    cmp edx, 0
    jge loopThroughDates

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
