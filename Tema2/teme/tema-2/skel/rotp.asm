section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; TODO: Implment rotp
    ;; FREESTYLE STARTS HERE

 rotpEntry:

    ;; FORMULA: ciphertext[i] = plain[i] ^ key[len - i - 1]

    ;; Make registries 0
    xor eax, eax
    xor ebx, ebx
    ;; We use ebx for our itterator

loopThroughString:

    ;; take plain[i] and put in into stack
    xor eax, eax
    mov al, [esi + ebx]
    push eax ;; plain[i]

    ;; Create len - i - 1 in order to take key[len - i - 1]
    xor eax, eax
    mov al, cl
    sub al, bl
    sub al, 1 ;; len - i - 1
    
    xor ch, ch
    mov ch, bl ;; ch = itterator
    xor ebx, ebx
    mov ebx, eax ;; ebx == len - i - 1, ch == itterator;
    xor al, al
    mov al, [edi + ebx] ;; key[len - i - 1]
    xor ebx, ebx
    pop ebx ;; plain[i]

    
    xor eax, ebx ;; function xor
    xor ebx, ebx ;; ebx = 0
    mov bl, ch ;; bl becomes itterator
    mov [edx + ebx], al ;; writing exactly 1 byte
    
    add bl, 1
    cmp bl, cl
    jl loopThroughString

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY