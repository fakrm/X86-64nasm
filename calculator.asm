section .data

    ; Messages

    msg1        db      10,'- Hello Calculator-',10,0
    lmsg1       equ     $ - msg1 ;calculate the length of msg1 and save it in lmsg1

    msg2        db      10,'Number 1: ',0 ;10 is newline in ASCII
    lmsg2       equ     $ - msg2

    msg3        db      'Number 2: ',0
    lmsg3       equ     $ - msg3

    msg4        db      10,'1. Add',10,0
    lmsg4       equ     $ - msg4

    msg5        db      '2. Subtract',10,0
    lmsg5       equ     $ - msg5

    msg6        db      '3. Multiply',10,0
    lmsg6       equ     $ - msg6

    msg7        db      '4. Divide',10,0
    lmsg7       equ     $ - msg7

    msg8        db      'Operation: ',0
    lmsg8       equ     $ - msg8

    msg9        db      10,'Result: ',0
    lmsg9       equ     $ - msg9

    msg10       db      10,'Invalid Option',10,0
    lmsg10      equ     $ - msg10

    nlinea      db      10,10,0
    lnlinea     equ     $ - nlinea

section .bss

    ; Spaces reserved for storing the values provided by the user but uninitialized

    opc:        resb    2 ;operation 2*8 bits
    num1:       resb    10
    num2:       resb    10
    result:     resb    11

section .text

    global _start

_start:

    ; Print on screen the message 1
    mov eax, 1 ;sys write
    mov edi, 1 ;stdout
    mov edx, lmsg1 ;length of the message should be printed
    lea rsi, [msg1]
    syscall

    ; Print on screen the message 2
    mov eax, 1 ;sys write
    mov edi, 1 ;file descriptor
    mov edx, lmsg2
    lea rsi, [msg2]
    syscall

    ; get num1 value.
    mov eax, 0          ; sys read
    mov edi, 0          ; file descriptor 0 std input
    mov edx, 10
    lea rsi, [num1]
    syscall



    ; Print on screen the message 3
    mov eax, 1
    mov edi, 1
    mov edx, lmsg3
    lea rsi, [msg3]
    syscall

    ;  get num2 value.
    mov eax, 0          ; sys_read system call number
    mov edi, 0          ; file descriptor 0 (stdin)
    mov edx, 10
    lea rsi, [num2]
    syscall


    ; Print on screen the message 4
    mov eax, 1
    mov edi, 1
    mov edx, lmsg4
    lea rsi, [msg4]
    syscall

    ; Print on screen the message 5
    mov eax, 1
    mov edi, 1
    mov edx, lmsg5
    lea rsi, [msg5]
    syscall

    ; Print on screen the message 6
    mov eax, 1
    mov edi, 1
    mov edx, lmsg6
    lea rsi, [msg6]
    syscall

    ; Print on screen the message 7
    mov eax, 1
    mov edi, 1
    mov edx, lmsg7
    lea rsi, [msg7]
    syscall

    ; Print on screen the message 8
    mov eax, 1
    mov edi, 1
    mov edx, lmsg8
    lea rsi, [msg8]
    syscall

    ;  get the option selected.
    mov eax, 0          ; sys_read system call number
    mov edi, 0          ; file descriptor 0 (stdin)
    mov edx, 2
    lea rsi, [opc]
    syscall

    movzx rax, byte [opc]  ; Move the selected option to the register rax , byte will move
    sub rax, '0'           ; Convert from ascii to decimal

    ; compare the user operation to menu

    cmp rax, 1
    je add ;jump if equal
    cmp rax, 2
    je subtract
    cmp rax, 3
    je multiply
    cmp rax, 4
    je divide

    ; If the value entered by the user does not meet any of the above
    ; conditions then  show an error message and  close the program.
    mov eax, 1 ;sys write cause it is 1
    mov edi, 1 ;file descriptor 1 = stdout
    mov edx, lmsg10 ;length of msg10 will go to edx in bytes
    lea rsi, [msg10] ;load the address of msg10 to rsi
    syscall

    jmp exit ;terminate the program

add:
    ; keep the numbers in the registers al and bl
    mov al, byte [num1]
    mov bl, byte [num2]

    ; Convert from ASCII to decimal
    sub al, '0'
    sub bl, '0'

    ; Add
    add al, bl

    ; Conversion from decimal to ASCII and store the result as a string
    movzx ax, al         ; Zero-extend to a word
    mov ecx, 10          ; Set divisor to 10
    lea rdi, [result+2]  ; Point to the end of the result string

convert_loop:
    xor edx, edx         ; Clear any previous remainder
    div ecx             ; Divide AX by 10, result in AX, remainder in DX
    add dl, '0'          ; Convert remainder to ASCII
    dec rdi              ; Move pointer to the left
    mov [rdi], dl        ; Store ASCII character
    test ax, ax          ; Check if quotient is zero
    jnz convert_loop    ; If not, continue the loop


    ; it means  have a second digit, so  need to process it.
    test dl, dl          ; Check if remainder is non-zero
    jnz convert_second_digit

 convert_done:

; Print on screen the message 9
mov eax, 1
mov edi, 1
mov edx, lmsg9
lea rsi, [msg9]
syscall

; Print on screen the result
mov eax, 1
mov edi, 1
mov edx, 11 ; Adjust the length for two digits and null terminator
lea rsi, [result]
syscall

;end the program
jmp exit

convert_second_digit:
    dec rdi              ; Move pointer to the left
    mov byte [rdi], '0'   ; Store '0' in the current position
    dec rdi              ; Move pointer to the left again
    add byte [rdi], dl   ; Convert second digit to ASCII and store it
    jmp convert_done     ; Continue with the rest of your code


subtract:
    ;  keep the numbers in the registers al and bl
    mov al, byte [num1]
    mov bl, byte [num2]

    ; Convert from ASCII to decimal
    sub al, '0'
    sub bl, '0'

    ; Subtract
    sub al, bl

    ; Check if the result is negative
    js negative_result

    ; If not negative, convert result to ASCII
    add al, '0'

    ;  move the result
    mov byte [result], al
    mov byte [result + 1], 0 ; Null-terminate the result


    ; Print on screen the message 9
    mov eax, 1
    mov edi, 1
    mov edx, lmsg9
    lea rsi, [msg9]
    syscall

    ; Print on screen the result
    mov eax, 1
    mov edi, 1
    mov edx, 3 ; Adjust the length for two digits and null terminator
    lea rsi, [result]
    syscall

    ; end the program
    jmp exit

negative_result:
    ; If the result is negative, negate it and convert to ASCII
    neg al
    add al, '0'

  ; move the result
    mov byte [result], '-'
    mov byte [result + 1], al
    mov byte [result + 2], 0 ; Null-terminate the result

    ; Print on screen the message 9
    mov eax, 1
    mov edi, 1
    mov edx, lmsg9
    lea rsi, [msg9]
    syscall

    ; Print on screen the result
    mov eax, 1
    mov edi, 1
    mov edx, 4 ; Adjust the length for two digits, sign, and null terminator
    lea rsi, [result]
    syscall

    ;  end the program
    jmp exit

  multiply:
      mov al, byte [num1]
      mov bl, byte [num2]
      sub al, '0'
      sub bl, '0'
      mul bl

      ; Convert result to ASCII
      movzx ax, al         ; Zero-extend to a word
      mov ecx, 10          ; Set divisor to 10
      lea rdi, [result+3]  ; Point to the end of the result string

      ; Convert first digit
      xor edx, edx         ; Clear any previous remainder
      div ecx             ; Divide AX by 10, result in AX, remainder in DX
      add dl, '0'          ; Convert remainder to ASCII
      dec rdi              ; Move pointer to the left
      mov [rdi], dl        ; Store ASCII character

      ; Convert second digit
      xor edx, edx         ; Clear any previous remainder
      div ecx             ; Divide AX by 10, result in AX, remainder in DX
      add dl, '0'          ; Convert remainder to ASCII
      dec rdi              ; Move pointer to the left
      mov [rdi], dl        ; Store ASCII character

      ; If you want to handle more than two digits, you can add more conversion steps here

      ; Print on screen the message 9
      mov eax, 1
      mov edi, 1
      mov edx, lmsg9
      lea rsi, [msg9]
      syscall

      ; Print on screen the result
      mov eax, 1
      mov edi, 1
      mov edx, 4 ; Adjust the length for two digits and null terminator
      lea rsi, [result]
      syscall

      ;  end the program
      jmp exit

    divide:
        ;  store the numbers in registers al and bl
        mov al, byte [num1]
        mov bl, byte [num2]

        mov rdx, 0

        ; Convert from ascii to decimal
        sub al, '0'
        sub bl, '0'

        ; Division. AL = AX / BX
        div bl

        ; Conversion from decimal to ascii
        add al, '0'

        ;  move the result
        mov byte [result], al

        ; Print on screen the message 9
        mov eax, 1
        mov edi, 1
        mov edx, lmsg9
        lea rsi, [msg9]
        syscall

        ; Print on screen the result
        mov eax, 1
        mov edi, 1
        mov edx, 1
        lea rsi, [result]
        syscall

        ;  end the program
        jmp exit


    exit:
        ; Print on screen two new lines
        mov eax, 1
        mov edi, 1
        mov edx, lnlinea
        lea rsi, [nlinea]
        syscall

        ; End the program
        mov eax, 60         ; sys_exit system call number
        xor edi, edi        ; exit code 0
        syscall