assume cs:code, ds: data, ss: stack

data segment
    message1 db 'hzytql','$'
    message2 db 'xxxxxxx','$'
    input1 db 64, ?, 64 DUP('$')
data ends

stack segment
    dw 0
stack ends

code segment
    start:
        mov ax, data
        mov ds, ax

        lea dx, message1
        mov ah, 09h
        int 21h

        lea dx, message2
        mov ah, 09h
        int 21h

        lea dx, input1
        mov ah, 0ah
        int 21h

        mov ah, 4ch
        int 21h
code ends
end start
