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

	mov     rax, 1          ; System call for write
	mov     rdi, 1          ; File handle 1 is stdout

	mov rdx, 0
	mov dl, byte[text+msg_length]

	lea rsi,[text+status_msg]
	syscall                 ; invoke operating system to do the write

	; Convert dword endian...
	; eax has value to convert
	; Will return converted value in eax
  call printLF
;Print a nice name for this field
	mov rsi, track_obj
	mov rdx, 17
	mov     rax, 1          ; System call for write
	mov     rdi, 1          ; File handle 1 is stdout
  syscall


;Now, convert a field's endianness
	mov eax, dword[text + track_object_nbr]
	mov r12, 0  ; j = 0
	call cvtEndian
;Print what is in eax

 getdword:
	cmp eax, 0
	jz printDword

  cdq
	div dword[ten] ; divide num/10
	mov dword[num], eax ; num = num/10

	mov dword[rem], edx

	add byte[rem], '0'
	mov dl, byte[rem]

	mov byte[string+r12], dl
	inc r12

  jmp getdword

 printDword:
 mov     rax, 1          ; System call for write
 mov     rdi, 1          ; File handle 1 is stdout
 mov 		 rsi, string
 mov     rdx, 4
 syscall
 call printLF

 exit:
	mov     rax, 60         ; System call for exit
	xor     rdi, rdi        ; exit code 0
	syscall                 ; Invoke operating system to do the exit

 printLF:
  mov     rax, 1          ; System call for write
  mov     rdi, 1          ; File handle 1 is stdout
  mov 		rsi, var
  mov     rdx, 1
  syscall
	ret

	cvtEndian:
         push    rbx
 ;                            start with ; eax = 4 3 2 1
         rol     eax, 8                  ; eax = 3 2 1 4
         mov     ebx, eax
         and     eax, 0x00ff00ff         ; eax = - 2 - 4
         and     ebx, 0xff00ff00         ; ebx = 3 - 1 -
         ror     ebx, 16                 ; ebx = 1 - 3 -
         or      eax, ebx                ; eax = 1 2 3 4
         pop     rbx
				 ret
section .data
    ten dd 10
    rem db 0
    num db 0
		var db 10
    track_obj db "track_object_nbr "
    filename db "sat41x10.dat", 0 ; declares filename to be the satellite.dat file
    Key:     db 	0x36, 0x13, 0x92, 0xa5, 0x5a, 0x27, 0xf3, 0x00, 0x32 ; declare the key to be decrypt, 9 bytes long
    SYS_OPEN  equ 2 ;constant declaration to open a file
    SYS_READ  equ 0 ;constant declaration to read a file
    SYS_CLOSE equ 3 ;constant declaration to close the file
    O_RDONLY  equ 0 ;constant declartion to set a file to be "read-only"

section .bss
	text resb 180  ; reserve 180 bytes for the text to be read
	string resb 20 ; reserve 20 bytes for string
