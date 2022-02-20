;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .data
    myTags times CACHE_LINES dd 0 
    myIndex dd 0
    myAddress dd 0
    myReg dd 0
    myCache dd 0

section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache cacheMiss)
    ;; DO NOT MODIFY

    ;; TODO: Implment load
    ;; FREESTYLE STARTS HERE

cacheEntry:

    ;; Since most registries are used, we make our life's easier and use
    ;; variables for data
    mov [myReg], eax
    mov [myTags], ebx
    mov [myCache], ecx   
    mov [myAddress], edx  
    mov [myIndex], edi
    
    ;; Free all registries
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    xor edi, edi
    xor esi, esi
    
    ;; Obtain MyTags array, tag and offset
    mov ebx, [myTags] ;; my tags
    mov edx, [myAddress]
    
    ;; Edx == tag
    shr edx, 3 ;; tag
    ;; Edi == offset
    mov edi, [myAddress]
    and edi, 7 ;; 7 is 111 in binary == mask to take last 3 bytes

    ;; Loop through tags
    xor ecx, ecx
    mov ebx, [myTags]
searchTags: 

    ;; Compare tags[index] with calculated tag
    ;; If equals ==> cacheHit
    mov eax, [ebx + ecx * 4]
    cmp eax, edx
    je cacheHit

    ;; Continue loop
    inc cl
    cmp cl, CACHE_LINES
    jl searchTags

    ;; If no hit was found, then it's a cachecacheMiss
cacheMiss:

    ;; edx == tag to put in MyTags array
    ;; ebx == myTags array
    ;; ecx == index == where to put in array

    ;; Put tag in myTags array
    xor ecx, ecx
    mov ecx, dword [myIndex]
    mov [ebx + ecx * 4], edx

    ;; Prepare regestries for moving data from RAM into cache
    xor ecx, ecx
    xor eax, eax
    xor edx, edx
    xor edi, edi
    xor esi, esi
    mov edi, [myIndex]

    ;; Loop through cache line to move data from RAM into cache
    loopCacheLine:
        
        ;; Save ecx value into stack to restore later
        push ecx

        ;; Eax = cache_line_size * index (line where to put data)
        xor eax, eax
        xor edx, edx
        mov eax, CACHE_LINE_SIZE
        mul edi
        
        ;; Edx becomes the beggining of line myIndex == cache[i][0]
        add ecx, eax 
        xor edx, edx
        mov edx, [myCache]

        ;; Eax becomes the address of the beggining of data line in RAM
        xor eax, eax
        mov eax, [myAddress]
        shr eax, 3
        shl eax, 3

        ;; Esi becomes the increment from loopCacheLine, we also save the value
        pop esi
        push esi

        ;; Eax becomes the address data index data from RAM
        add eax, esi

        ;; Esi becomes the actual data
        xor esi, esi
        mov esi, [eax]

        ;; We put the value in Cache
        mov [edx + ecx], esi
        xor eax, eax
        mov eax, [edx + ecx]

        ;; Continue the loopCacheLine loop
        xor ecx, ecx
        pop ecx
        inc cl
        cmp cl, CACHE_LINE_SIZE
        jl loopCacheLine

    xor ecx, ecx
    mov ecx, [myIndex]

    ;; Case we have the value stored in cache
cacheHit:

    ;; Prepare regestries
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    xor esi, esi
    xor edi, edi
    xor edx, edx

    ;; Edi becomes offsett
    mov edi, [myAddress]
    and edi, 7 ;; 7 is 111 in binary == mask to take last 3 bytes

    ;; Eax becomes the index for the begging of line containing searched data
    ;; Then we add edi, which is the offset, so we obtain the needed data
    mov eax, ecx
    mov esi, dword CACHE_LINE_SIZE
    mul esi
    add eax, edi

    ;; We take the value from cache and put it in myReg (index for cache == eax)
    xor edx, edx
    xor esi, esi
    mov edx, [myReg]
    mov ebx, [myCache]
    mov esi, [eax + ebx]
    mov [edx], esi
    mov esi, [edx]
    
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


