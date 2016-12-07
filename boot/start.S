# waccOS start file

.equ Mode_IRQ, 0x12
.equ Mode_SVC, 0x13
.equ I_Bit, 0x80
.equ F_Bit, 0x40

.equ CPSRIRQ, (Mode_IRQ | I_Bit | F_Bit)
.equ CPSRIRQON, (Mode_IRQ | F_Bit)

.equ CPSRSVC, (Mode_SVC | I_Bit | F_Bit)
.equ CPSRSVCON, (Mode_SVC | F_Bit)

.macro drop_to_irq_mode
    msr CPSR_c, #CPSRIRQ
.endm

.macro rise_to_svc_mode
    msr CPSR_c, #CPSRSVC
.endm

.globl _start
_start:
    mov     r0, #0x6000
    drop_to_irq_mode
    mov     sp, r0

    rise_to_svc_mode
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

