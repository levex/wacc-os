.globl _start
_start:
	mov r0, #1
	ldr r1, =hello_world_str
	mov r2, #13
	mov r7, #4
	swi 0
1:	b 1b

.balign 16
hello_world_str: .asciz "Hello, world!"
