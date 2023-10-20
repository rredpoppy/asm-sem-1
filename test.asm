bits 32 ;asamblare si compilare pentru arhitectura de 32 biti
; definim punctul de intrare in programul principal
global  start 

extern  exit ; indicam asamblorului ca exit exista, chiar daca noi nu o vom defini
import  exit msvcrt.dll; exit este o functie care incheie procesul, este definita in msvcrt.dll
        ; msvcrt.dll contine exit, printf si toate celelalte functii C-runtime importante
segment  data use32 class=data ; segmentul de date in care se vor defini variabilele 
	a db 0x3
    b dw 0xfded ; -0x213 base 10
    c dd 0x23e76
    d dq 0x11764f
    ; (b + c + d) - (a + d) = 0x23c60
segment  code use32 class=code ; segmentul de cod
start: 

	push    ebp           ; Save the base pointer
    mov     ebp, esp      ; Set the base pointer

    ; ( b + c + d )
    xor eax, eax ; clears eax
    mov ax, [b]
    cwde ; extend b to double while keeping sign
    add eax, [c] ; b + c
    cdq ; edx now holds the sign of b + c upper dword for use later
    add eax, [d] ; add the least significant dword of d
    push eax ; save least significant dword of result to stack
    mov eax, [d+32] ; move the higher dword of d into eax
    adc eax, edx ; add the carry to eax + edx (signed b + c upper dword); eax:ebx now holds the higer dword of the result; the edx part is necessary to maintain the sign of b + c
    push eax ; save higher dword to stack

    ; (d + a)
    xor eax, eax ; reset eax
    mov al, [a] ; sign extend eax
    cbw
    cwde
    add eax, [d] ; add lower dword of d to eax
    push eax ; push lower dword of current result
    mov eax, [d+32] ; load higher dword of d
    adc eax, 0 ; add the carry to higher dword
    pop ecx ; retrieve lower dword of current result
    pop ebx ; retrieve higher dword of previous result
    pop edx ; retrieve the lower dword of previous result
    sub ecx, edx ; substract with possible carry the lower dwords
    sbb eax, ebx ; substract higher dwords with carry; result is now eax:ecx

	push   dword 0 ;exit code fn
	call   [exit]
    
    pop ebp ; restoring base pointer
