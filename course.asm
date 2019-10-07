assume cs:code, ds: data, ss: stack

data segment
    ; constant area
    CRLF db 0dh,0ah,'$'
    MSG_WELCOME db 'Welcome to Student Managment System By U201816816, Yang Ziyue ',0dh,0ah,' 1. Insert Grade ',0dh,0ah,' 2. Query Grade ',0dh,0ah,' q. Exit',0dh,0ah,'$'
    MSG_INPUT_STUDENTID db 'Input StudentID: ','$'
    MSG_INPUT_GRADE db 'Input Grade: ','$'
    MSG_INPUT_RANK db 'Input Rank: ','$'
    MSG_PREFIX_STUDENTID db 'Target StudentID: ','$'
    MSG_PREFIX_GRADE db 'Target Grade: ','$'
    MSG_PREFIX_RANK db 'Target Rank: ','$'
    MSG_DEBUG_INFO db '[Debug Info] Last exectued input string: ','$'
    MSG_CONTINUE db 'Press Enter to continue ...','$'
    MSG_INSERT_OK db '[Success] INSERT OK',0dh,0ah,'$'
    ERR_FULL db '[Error] Already Full : Students count SHOULD NOT excceed 10 !',0dh,0ah,'$'
    ERR_INVALID_COMMAND db '[Error] INVALID Command!',0dh,0ah,'$'
    ERR_NOT_EXIST db '[Error] Wrong Student ID: target student NOT exist !',0dh,0ah,'$'
    
    ; variables
    input_buffer    db 20
                    db ?
                    db 20 dup(0)
    student_count   db 0
    student_table   db 10 dup(20 dup(0), 10 dup(0), 10 dup(0))
data ends

stack segment stack
    dw 20 DUP(0)
stack ends

code segment
    start:
        ; init ss, sp, ds registers
        mov ax, stack
        mov ss, ax
        mov sp, 0
        mov ax, data
        mov ds, ax
    first_input:
        lea dx, MSG_WELCOME
        mov ah, 09h
        int 21h

        call input_string

        mov ah, input_buffer + 1
        cmp ah, 1
        jne error_invalid_command

        mov al, input_buffer + 2

        cmp al, '1'
        je insert
        cmp al, '2'
        je query
        cmp al, 'q'
        je exit

        call error_invalid_command
        jmp first_input
    error_invalid_command:
        lea dx, ERR_INVALID_COMMAND
        mov ah, 09h
        int 21h

        ret
    output_CRLF:
        lea dx, CRLF
        mov ah, 09h
        int 21h

        ret
    exit:
        mov ah, 04ch
        int 21h
    insert_err_full:
        lea dx, ERR_FULL
        mov ah, 09h
        int 21h
        jmp first_input
    insert:
        cmp byte ptr [student_count], 10
        je insert_err_full

        mov al, 40
        mul byte ptr [student_count]
        mov di, ax

        lea dx, MSG_INPUT_STUDENTID
        mov ah, 09h
        int 21h
        call input_string
        mov bx, 0
        call memcpy

        lea dx, MSG_INPUT_GRADE
        mov ah, 09h
        int 21h
        call input_string
        mov bx, 20
        call memcpy

        lea dx, MSG_INPUT_RANK
        mov ah, 09h
        int 21h
        call input_string
        mov bx, 30
        call memcpy

        inc byte ptr [student_count]

        lea dx, MSG_INSERT_OK
        mov ah, 09h
        int 21h

        call press_enter_to_continue

        jmp first_input
    query:
        lea dx, MSG_INPUT_STUDENTID
        mov ah, 09h
        int 21h

        call input_string
        mov cl, byte ptr [student_count]
        mov ch, 0
        mov dx, 0 ; dl: loop index
    query_process:
        mov ah, 0
        mov al, 40
        mul dl
        mov di, ax
        mov bx, 0

        query_cpy_process:
            mov ah, byte ptr [input_buffer + 2 + bx]

            mov ah, byte ptr [input_buffer + 2 + bx]
            mov al, byte ptr [student_table + di + bx]

            cmp ah, al
            je query_next

            cmp ah, al
            jne query_process_loop_end
        query_next:
            mov ah, byte ptr [input_buffer + 2 + bx]
            cmp ah, '$'

            je print_student_info
            inc bx
            jmp query_cpy_process
    query_process_loop_end:
        cmp ah, '$'
        je query_next_loop
        mov ah, byte ptr [student_table + di + bx]
        cmp ah, '$'
        je query_next_loop
    query_next_loop:
        inc dl
        loop query_process

        jmp student_not_exist
    student_not_exist:
        lea dx, ERR_NOT_EXIST
        mov ah, 09h
        int 21h

        call press_enter_to_continue

        jmp first_input
    print_student_info:
        lea dx, MSG_PREFIX_STUDENTID
        mov ah, 09h
        int 21h

        lea dx, student_table[di]
        mov ah, 09h
        int 21h

        lea dx, CRLF
        mov ah, 09h
        int 21h

        lea dx, MSG_PREFIX_GRADE
        mov ah, 09h
        int 21h

        lea dx, student_table[di][20]
        mov ah, 09h
        int 21h

        lea dx, CRLF
        mov ah, 09h
        int 21h

        lea dx, MSG_PREFIX_RANK
        mov ah, 09h
        int 21h

        lea dx, student_table[di][30]
        mov ah, 09h
        int 21h

        call press_enter_to_continue
        jmp first_input
    press_enter_to_continue:
        lea dx, CRLF
        mov ah, 09h
        int 21h

        lea dx, MSG_CONTINUE
        mov ah, 09h
        int 21h

        call input_string
        lea dx, CRLF
        mov ah, 09h
        int 21h

        ret
    input_string:
        lea dx, input_buffer
        mov ah, 0ah
        int 21h

        mov al, input_buffer + 1
        add al, 2
        mov ah, 0

        mov si, ax
        mov input_buffer[si], '$'

        lea dx, CRLF
        mov ah, 09h
        int 21h

        ; debug info output
        ; lea dx, MSG_DEBUG_INFO
        ; mov ah, 09h
        ; int 21h

        ; lea dx, input_buffer + 2
        ; mov ah, 09h
        ; int 21h

        ; lea dx, CRLF
        ; mov ah, 09h
        ; int 21h
        ret
    memcpy:
        mov ah, 0
        mov al, 40
        mov dl, byte ptr [student_count]
        mul dl
        add bx, ax
        ; function: copy string from buffer to the right space
        mov cl, input_buffer + 1
        inc cl
        mov ch, 0
        mov di, 0
    memcpy_loop:
        mov al, byte ptr [input_buffer + 2 + di]
        mov byte ptr [student_table + bx + di], al
        inc di
        loop memcpy_loop
        ret
code ends
end start