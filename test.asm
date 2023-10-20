bits 32

section .data
    a db 0x3
    b dw 0xFDED ; -531 in decimal
    c dd 0x23E76
    d dq 0x11764F

section .text
global _start

extern _exit
import _exit, msvcrt.dll

_start:

    push ebp                ; Save the base pointer
    mov ebp, esp            ; Set the base pointer

    ; Calculate (b + c + d)
    xor eax, eax            ; Clear EAX (lower 32 bits of the result)
    xor edx, edx            ; Clear EDX (upper 32 bits of the result)
    mov ax, [b]             ; Move b into AX
    cwde                    ; Sign-extend AX to EAX
    add eax, [c]            ; Add c to EAX
    adc edx, 0              ; Add carry to EDX (initially 0)
    add eax, [d]            ; Add least significant 32 bits of d to EAX
    adc edx, dword [d+4]    ; Add most significant 32 bits of d to EDX

    ; Calculate (a + d)
    xor ebx, ebx            ; Clear EBX (lower 32 bits of the result)
    xor ecx, ecx            ; Clear ECX (upper 32 bits of the result)
    mov bl, [a]             ; Move a into BL (sign-extend to EBX)
    cbw                     ; Sign-extend BL to BX
    cwde                    ; Sign-extend BX to EAX
    add ebx, [d]            ; Add least significant 32 bits of d to EBX
    adc ecx, dword [d+4]    ; Add most significant 32 bits of d to ECX

    ; Subtract (a + d) from (b + c + d)
    sub eax, ebx            ; Subtract lower 32 bits
    sbb edx, ecx            ; Subtract upper 32 bits with borrow

    ; Exit with the result in EAX (lower 32 bits)
    push dword 0            ; Exit code
    call [_exit]

    pop ebp                 ; Restore the base pointer
