# waccOS start file

.globl _start
_start:
	mov sp, #0x8000

	bl uart_init

	mov r0, #'w'
	bl uart_send_byte
	mov r0, #'a'
	bl uart_send_byte
	mov r0, #'c'
	bl uart_send_byte
	mov r0, #'c'
	bl uart_send_byte

	bye:
		b bye
