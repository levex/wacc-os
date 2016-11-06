# waccOS start file

.globl _start
_start:
	mov sp, #0x8000

	bye:
		b bye
