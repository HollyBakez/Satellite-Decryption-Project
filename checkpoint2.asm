%include "satStruct.inc"
global _start
section .text
_start:
;-------Opens the file----------
	mov rax, SYS_OPEN ; moves the open file command into the rax register
	mov rdi, filename ; moves our filename containing our sat data into rdi
	mov rsi, O_RDONLY ; sets the file to read only
	mov rdx, 0        ; moving a null into rdx
	syscall           ; call the system to do an exit

;--------Reads the file---------

	push rax          ; pushes rax open file command into the stack
	mov rdi, rax      ; moves rax into rdi, open file command passes to the filename var
	mov rax, SYS_READ ; moves the read-file command into the rax where the file is
	mov rsi, text     ; points to stored read-text location
	mov rdx, 180      ; 180 bytes to be read from the file
	syscall


;---------calling decrypt subroutine--------
  init:
  mov r9, 0 ; j =0
	mov r8, 0 ; i = 0
  resetr9:
	xor r9,r9

  decrypt:                ;subroutine called decrypt

	cmp r8, 180			; i < 180
	jae functionexit; if equal, then jump to our exit function

	mov r10b, byte[Key+r9] ; r9 is our j, move key value into r10b
	xor byte[text+r8], r10b	 ; r8 is our i
	inc  r9			; j++
	inc  r8			; i++
	cmp r9, 9  ; j > 9
	jae resetr9

	jmp decrypt		; loop through again

 functionexit:
	;syscall
	;ret

	mov     rax, 1          ; System call for write
	mov     rdi, 1          ; File handle 1 is stdout

	mov rdx, 0
	mov dl, byte[text+msg_length]

	lea rsi,[text+status_msg]
	syscall                 ; invoke operating system to do the write
	mov     rax, 60         ; System call for exit
	xor     rdi, rdi        ; exit code 0
	syscall                 ; Invoke operating system to do the exit



section .data
    filename db "sat41x10.dat", 0 ; declares filename to be the satellite.dat file
    Key:     db 	0x36, 0x13, 0x92, 0xa5, 0x5a, 0x27, 0xf3, 0x00, 0x32 ; declare the key to be decrypt, 9 bytes long
    SYS_OPEN  equ 2 ;constant declaration to open a file
    SYS_READ  equ 0 ;constant declaration to read a file
    SYS_CLOSE equ 3 ;constant declaration to close the file
    O_RDONLY  equ 0 ;constant declartion to set a file to be "read-only"

section .bss
	text resb 180  ; reserve 180 bytes for the text to be read
