section .data
    extern len_cheie, len_haystack
    numberOfLines db 0
    currentChar db 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; TODO: Implment columnar_transposition
    ;; FREESTYLE STARTS HERE
    

columnarEntry:

    ;; We do not create the actual matrix, we use a formula to take data
    ;; the character from the line i and column j in matrix is : 
    ;; i * numberOfColumns(key length) + j
    ;; We know that we want to traversal the matrix by columns in the order
    ;; from key. The algorithm would be:
    ;; int currentChar = 0; (Current char from cipherText)
    ;; for j : key
    ;;      for i : numberOfnumberOfLines (ceil( l_plain/l_key ) + 1)
    ;;          cipherText(currentChar++) = haystack(i * numberOfColumns + j)
    ;; We use variables: numberOfnumberOfLines and currentChar
    
    xor eax, eax
    xor ecx, ecx
    xor edx, edx
    mov [currentChar], byte 0
    mov [numberOfLines], byte 0

    ;; Calculate the numberOfLines = (ceil( l_plain/l_key ) + 1)
    mov al, byte [len_haystack]
    mov dl, byte [len_cheie]
    div dl
    xor ah, ah
    add al, 1
    mov [numberOfLines], al 

    xor eax, eax
    xor ecx, ecx

 loopThroughKeys:
    
    ;; We use cl as increment


    ;; Take current value from Key
    xor edx, edx
    mov edx, [edi + ecx * 4] 

    ;; We need ecx later
    push ecx 
    xor ecx, ecx

    ;; We also use cl for increment, take it's initial value from stack later
    loopThroughLines:
        ;; idea = we add edx to i * lane size == len_cheie

        ;; We need the registry, save the value
        push edx
        xor eax, eax
        xor edx, edx

        ;; i (currentLine) * numberOfColums
        mov al, [len_cheie]
        mul cl
        ;; Now eax contains product, ecx is the increment (i)

        ;; Edx becomes the column from key
        xor edx, edx
        pop edx 
        
        ;; We save edx again in stack to recover later
        push edx
        ;; edx == i * currentLine + currentColumn (index for haystack)
        add edx, eax 

        ;; Al becomes the index for cipherText
        xor eax, eax
        mov al, [currentChar]
        
        ;; We save ecx to use value later
        push ecx
        xor ecx, ecx

        ;; We check whether the haystack has ended
        cmp dl, [len_haystack]
        jae overSize


        ;; Move char from haystack into cl
        mov cl, [esi + edx]
        
        ;; Put char saved into cl inside cipherText at the right index
        mov [ebx + eax], cl
        ;; We increment currentChar
        add [currentChar], byte 1

        ;; In case haystack has no more characters to offer on that column
        ;; Also does regular incrementation for loopThroughLines
overSize:
        xor ecx, ecx
        pop ecx 

        xor edx, edx
        pop edx 
        xor eax, eax

        inc cl
        cmp cl, [numberOfLines]
        jl loopThroughLines

    ;; We continue the loopThroughKey loop
    xor ecx, ecx
    pop ecx
    inc cl
    cmp cl, [len_cheie]
    jl loopThroughKeys

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY