assume cs:code, ds: data, ss: stack

data segment
    output dw 0
data ends

stack segment
    dw 0
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov ax, 0
        mov cx, 12

        jmp seg1
    seg1:
        inc ax
        loop seg1

        mov output, ax

        mov ah, 4ch
        int 21h
code ends
end start
