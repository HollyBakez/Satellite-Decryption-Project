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
	mov r9, 0 ; j =0
	mov r8, 0 ; i = 0
	call decrypt

  decrypt:                ;subroutine called decrypt
	call loop
	loop:
	cmp r8, 180			; i < 180
	jnl functionexit; if equal, then jump to our exit function

	mov r10b, byte[Key+r9] ; r9 is our j, move key value into r10b
  xor byte[text+r8], r10b	 ; r8 is our i ; xor-ing  text 'i' index with r9 'j' index, stores result into byte text
	inc  r9			; j++
	inc  r8			; i++

	cmp r9, 9  ; j > 9
	jnl loop

	mov r9, 0 ; j = 0
	jmp loop		; loop through again

	syscall

	functionexit:
	mov rax, 60
	xor rdi, rdi
	syscall


section .data
    filename db "sat41x10.dat", 0 ; declares filename to be the satellite.dat file
    Key:     db 0x36,0x13,0x92,0xa5,0x5a,0x27,0xf3,0x00,0x32 , 9 ; declare the key to be decrypt, 9 bytes long
    SYS_OPEN  equ 2 ;constant declaration to open a file
    SYS_READ  equ 0 ;constant declaration to read a file
    SYS_CLOSE equ 3 ;constant declaration to close the file
    O_RDONLY  equ 0 ;constant declartion to set a file to be "read-only"

section .bss
	text resb 180  ; reserve 180 bytes for the text to be read
