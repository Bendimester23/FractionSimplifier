SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

section .bss
    out: resb 6
    tempnum: resb 6
    tempdenom: resb 6
    innum: resb 6
    indenom: resb 6

section .data
    greet db 'Hello, user!', 0xA
    greetLengt equ $ - greet
    newline db '', 0xA
    newlineLength equ $ - newline

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
        cmp ax,bx
        jg subtr
        sub bx,ax
    cond:
    cmp ax,bx
    jne loop01
    mov cx,bx
    xor ax,ax
    xor bx,bx
    ret
    subtr:
        sub ax,bx
        jmp cond

;input: numerator, denominator
%macro simplify_fraction 2 
    mov [tempnum],%1
    mov [tempdenom],%2
    mov ax,%1
    mov bx,%2
    call gcd
    mov ax,[tempnum]
    idiv cl
    xchg ax,[tempnum]
    mov ax,[tempdenom]
    idiv cl
    xchg ax,[tempdenom]

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
    mov ecx,greet
    mov edx,greetLengt
    call print

    call read
    call atoi
    mov [innum],eax

    call read
    call atoi
    mov [indenom],eax

    mov eax,[innum]
    mov ebx,[indenom]
    simplify_fraction ax,bx
    call linebreak
    mov eax,[tempnum]
    call showeaxd
    call linebreak
    mov eax,[tempdenom]
    call showeaxd
    call linebreak

    mov eax,SYS_EXIT
    int 80h

