; a - byte, b - word, c - double word, d - qword - Signed representation
; (b+c+d)-(d+a)
section .text
    extern printf
    extern exit
    global _start

_start:
    push    ebp           ; Save the base pointer
    mov     ebp, esp      ; Set the base pointer

    ; ( b + c + d )
    xor eax, eax ; clears eax
    mov [b], ax
    cwde ; extend b to double while keeping sign
    add eax, [c] ; b + c
    add eax, [d] ; add the least significant dword of d
    push eax ; save least significant dword of result to stack
    mov [d+32], eax ; move the higher dword of d into eax
    adc eax, 0 ; add the carry to eax; eax:ebx now holds the higer dword of the result
    push eax ; save higher dword to stack

    ; (d + a)
    xor eax, eax ; reset eax
    mov [a], al ; sign extend eax
    cbw
    cwde
    add eax, [d] ; add lower dword of d to eax
    pop ebx ; retrieve higher dword of previous result
    push eax ; push lower dword of current result
    mov [d+32], eax ; load higher dword of d
    adc eax, ebx ; add the higher dwords of the result
    pop ebx ; retrieve lover dword of current result
    pop ecx ; retrieve lower dword of previous result
    sbb ebx, ecx ; add them together
    adc eax, 0 ; add carry



    push    dword [a]     ; Push the address of the integer onto the stack
    push    dword fmt     ; Push the address of the format string onto the stack
    call    printf        ; Call the printf function
    add     esp, 8        ; Clean up the stack

    mov eax, 0xa
    call exit

    pop ebp               ; Restore stack

section .data
    a db 0x3
    b dw -0x213
    c dd 0x23e76
    d dq 0x11764f
    fmt db "EAX: #%08X", 10, 0
