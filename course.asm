assume cs:code, ds: data, ss: stack

data segment
    message1 db 'Welcome to Student Managment System By U201816816 ',0dh,0ah,' 1. Input Grade ',0dh,0ah,' 2. Query Grade ',0dh,0ah,'$'
    message2 db 'Input StudentID, Grade, Rank repectively ',0dh,0ah,'  NOTE : [MUST] NOT excceed 10 Students','$'
    message3 db 'Press StudentID',0dh,0ah,'$'

data ends

stack segment
    dw 0
stack ends

code segment
    start:
        mov ax, stack
        mov ss, ax
        mov sp, 0
        mov ax, data
        mov ds, ax
        
        lea dx, message1
        mov ah, 09h
        int 21h

        mov ah, 04ch
        int 21h
code ends
end start
