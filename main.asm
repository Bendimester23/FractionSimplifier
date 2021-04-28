SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

section .bss
    tempnum: resb 12
    tempdenom: resb 12
    innum: resb 12
    indenom: resb 12

section .data
    greet db 'Hello, user!', 0xA
    greetLengt equ $ - greet
    newline db '', 0xA
    newlineLength equ $ - newline
    dzeroException db 'Cannot divide by zero!', 0xA, "Please enter another denominator!", 0xA
    dzeroLen equ $ - dzeroException
    instOne db 'Enter a numerator!', 0xA
    instOneLen equ $ - instOne
    instTwo db 'Enter a denominator!', 0xA
    instTwoLen equ $ - instTwo
    num db 'Your numerator: '
    numLen equ $ - num
    denom db 'Your denominator: '
    denomLen equ $ - denom
    computing db '* Simplifying your fraction... *', 0xA
    computingLen equ $ - computing
    s2 db '********************************', 0xA ; could have used times here btw
    s2Len equ $ - s2

section .text
    global _start

print:
    mov eax,SYS_WRITE
    mov ebx,STDOUT
    int 80h
    ret

linebreak:
    mov ecx,newline
    mov edx,newlineLength
    call print
    ret

read:
    mov eax,SYS_READ
    mov ebx,STDIN
    int 80h
    ret

showeaxd:
    push eax
    push ebx
    push ecx
    push edx
    push esi
   
    sub esp, 10h ; an arbitrary "round number"
    lea ecx, [esp + 12]  ; another arbitrary number
    mov ebx, 10  ; we want to divide by 10
    xor esi, esi  ; counter
    mov byte [ecx], 0 ; why do I do this? I dunno.
.top:   
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    inc esi
    or eax, eax
    jnz .top
   
    mov edx, esi
    mov ebx, 1
    mov eax, 4
    int 80h

    add esp, 10h

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

gcd: ;finds the greatest common divisor of AX and BX, return on CX
    jmp cond
    loop01:
        cmp eax,ebx
        jg subtr
        sub ebx,eax
    cond:
    cmp eax,ebx
    jne loop01
    mov ecx,ebx
    xor eax,eax
    xor ebx,ebx
    ret
    subtr:
        sub eax,ebx
        jmp cond

;input: numerator, denominator
%macro simplify_fraction 2 
    mov [tempnum],%1
    mov [tempdenom],%2
    mov eax,%1
    mov ebx,%2
    call gcd
    mov edx,0
    mov eax,[tempnum]
    cdq
    idiv ecx
    xchg eax,[tempnum]
    mov edx,0
    mov eax,[tempdenom]
    cdq
    idiv ecx
    xchg eax,[tempdenom]

%endmacro
;input on edx, output on eax
atoi:
    xor eax, eax ; zero a "result so far"
.top:
    movzx edx, byte [ecx] ; get a character
    inc ecx ; ready for next one
    cmp edx, '0' ; valid?
    jb .done
    cmp edx, '9'
    ja .done
    sub edx, '0' ; "convert" character to number
    imul eax, 10 ; multiply "result so far" by ten
    add eax, edx ; add in current digit
    jmp .top ; until done
.done:
    ret

_start:
    mov ecx,greet ; greet
    mov edx,greetLengt
    call print

    mov ecx,instOne ; enter numerator
    mov edx,instOneLen
    call print

    call read ; read
    call atoi
    mov [innum],eax

    mov ecx,instTwo
    mov edx,instTwoLen
    call print

enterdenom:
    call read
    call atoi
    cmp eax,0
    je divideZeroException
    mov [indenom],eax

    mov ecx,s2
    mov edx,s2Len
    call print

    push ecx ; fancy computing message
    push edx
    mov ecx,computing
    mov edx,computingLen
    call print
    pop edx
    pop ecx
    call print

    mov eax,[innum] ; simplify fraction
    mov ebx,[indenom]
    simplify_fraction eax,ebx

    mov ecx,num ; print numerator
    mov edx,numLen
    call print
    mov eax,[tempnum]
    call showeaxd
    call linebreak

    mov ecx,denom ; print denominator
    mov edx,denomLen
    call print
    mov eax,[tempdenom]
    call showeaxd
    call linebreak

    mov eax,SYS_EXIT
    int 80h

divideZeroException:
    push eax
    mov ecx, dzeroException
    mov edx, dzeroLen
    call print
    pop eax
    jmp enterdenom


