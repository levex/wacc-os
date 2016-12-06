# waccOS start file

.equ Mode_IRQ, 0x12
.equ Mode_SVC, 0x13
.equ I_Bit, 0x80
.equ F_Bit, 0x40

.equ CPSRVAL1, (Mode_IRQ | I_Bit | F_Bit)
.equ CPSRVAL2, (Mode_SVC | I_Bit | F_Bit)

.globl _start
_start:
    mov     r0, #0x6000
    msr     CPSR_c, #CPSRVAL1
    mov     sp, r0

    msr     CPSR_c, #CPSRVAL2
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


    bl kernel_main

	bye:
		b bye
