assume cs:code, ds: data, ss: stack

data segment
    qq db 'qqqqqqq'
data ends

stack segment stack
    dw 0
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        mov ah, byte ptr[qq]
        
        mov ah, 4ch
        int 21h
code ends
end start
