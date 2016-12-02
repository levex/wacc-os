.section ".data"

.balign 16
fault_reset_str: .asciz "Reset fault happened\n"
.balign 16
fault_undefined_str: .asciz "Undefined isntructionfault happened\n"
.balign 16
fault_swi_str: .asciz "SWI fault happened\n"
.balign 16
fault_prefetch_abort_str: .asciz "Prefetch abort fault happened\n"
.balign 16
fault_data_abort_str: .asciz "Data abort fault happened\n"
.balign 16
fault_reserved_str: .asciz "Reserved (WTF) fault happened\n"
.balign 16
fault_irq_str: .asciz "IRQ fault happened\n"
.balign 16
fault_fiq_str: .asciz "FIQ fault happened\n"

.section ".text"

.balign 4
undef_stack: .skip 4 * 32

fault_reset:
    ldr r0, =fault_reset_str
    bl uart_send_string
    1: b 1b

fault_undefined:
    ldr sp, =undef_stack
    push {lr}
    ldr r0, =fault_undefined_str
    bl uart_send_string
    pop {lr}
    mov r0, lr
    bl uart_send_int_hex
    1: b 1b

fault_swi:
    push {lr}
    push {r0}
    ldr r0, =fault_swi_str
    bl uart_send_string
    pop {r0}
    push {r7}
    bl syscall_hub
    add sp, sp, #4
    pop {pc}

fault_prefetch_abort:
    ldr r0, =fault_prefetch_abort_str
    bl uart_send_string
    1: b 1b

fault_data_abort:
    ldr r0, =fault_data_abort_str
    bl uart_send_string
    1: b 1b

fault_reserved:
    ldr r0, =fault_reserved_str
    bl uart_send_string
    1: b 1b

fault_irq:
    ldr r0, =fault_irq_str
    bl uart_send_string
    1: b 1b

fault_fiq:
    ldr r0, =fault_fiq_str
    bl uart_send_string
    1: b 1b

.globl ivt_init
ivt_init:
  ldr r10, =ivt_table_precopy
  ldr r11, =0x00000000
  ldmia r10!, {r0-r7}
  stmia r11!, {r0-r7}
  ldmia r10,  {r0-r7}
  stmia r11,  {r0-r7}
  mov pc, lr

.balign 16
ivt_table_precopy:
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  ldr pc, [pc, #0x18]
  .word fault_reset
  .word fault_undefined
  .word fault_swi
  .word fault_prefetch_abort
  .word fault_data_abort
  .word fault_reserved
  .word fault_irq
  .word fault_fiq
