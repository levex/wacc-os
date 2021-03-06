.section ".data"

.balign 16
fault_reset_str: .asciz "Reset fault happened\n"
.balign 16
fault_undefined_str: .asciz "Undefined isntructionfault happened\n"
.balign 16
fault_swi_str: .asciz "SWI fault happened\n\r"
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

.balign 4
undef_stack: .skip 4 * 32

.section ".text"


.balign 16
fault_reset:
    ldr r0, =fault_reset_str
    bl uart_send_string
    1: b 1b

.balign 16
fault_undefined:
    ldr sp, =undef_stack
    push {lr}
    ldr r0, =fault_undefined_str
    bl uart_send_string
    pop {lr}
    mov r0, lr
    bl uart_send_int_hex
    1: b 1b

.balign 16
fault_swi:
    push {r11}
    ldr r11, =syscall_r0
    str r0, [r11]
    ldr r11, =syscall_r1
    str r1, [r11]
    ldr r11, =syscall_r2
    str r2, [r11]
    ldr r11, =syscall_r3
    str r3, [r11]
    ldr r11, =syscall_r4
    str r4, [r11]
    ldr r11, =syscall_r5
    str r5, [r11]
    ldr r11, =syscall_r6
    str r6, [r11]
    ldr r11, =syscall_r7
    str r7, [r11]
    ldr r11, =syscall_r8
    str r8, [r11]
    ldr r11, =syscall_r9
    str r9, [r11]
    ldr r11, =syscall_r10
    str r10, [r11]
    ldr r11, =syscall_r12
    str r12, [r11]
    ldr r11, =syscall_r14
    str r14, [r11]
    pop {r11}

    push {r10}
    ldr r10, =syscall_r11
    str r11, [r10]
    pop {r10}

    push {r7}
    bl syscall_hub
    add sp, sp, #4

    ldr r0, =syscall_r0
    ldr r0, [r0]
    ldr r1, =syscall_r1
    ldr r1, [r1]
    ldr r2, =syscall_r2
    ldr r2, [r2]
    ldr r3, =syscall_r3
    ldr r3, [r3]
    ldr r4, =syscall_r4
    ldr r4, [r4]
    ldr r5, =syscall_r5
    ldr r5, [r5]
    ldr r6, =syscall_r6
    ldr r6, [r6]
    ldr r7, =syscall_r7
    ldr r7, [r7]
    ldr r8, =syscall_r8
    ldr r8, [r8]
    ldr r9, =syscall_r9
    ldr r9, [r9]
    ldr r10, =syscall_r10
    ldr r10, [r10]
    ldr r11, =syscall_r11
    ldr r11, [r11]
    ldr r12, =syscall_r12
    ldr r12, [r12]
    ldr r14, =syscall_r14
    ldr r14, [r14]


    ## enable IRQs
    push {r0}
    mrs r0,cpsr
    bic r0,r0,#0x80
    msr cpsr_c,r0
    pop {r0}

    mov pc, lr

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

.macro irqsave_regs
     push {r11}
     ldr r11, =irq_save_r0
     str r0, [r11]

     ldr r11, =irq_save_r1
     str r1, [r11]

     ldr r11, =irq_save_r2
     str r2, [r11]

     ldr r11, =irq_save_r3
     str r3, [r11]

     ldr r11, =irq_save_r4
     str r4, [r11]

     ldr r11, =irq_save_r5
     str r5, [r11]

     ldr r11, =irq_save_r6
     str r6, [r11]

     ldr r11, =irq_save_r7
     str r7, [r11]

     ldr r11, =irq_save_r8
     str r8, [r11]

     ldr r11, =irq_save_r9
     str r9, [r11]

     ldr r11, =irq_save_r10
     str r10, [r11]

     ldr r11, =irq_save_r12
     str r12, [r11]

     pop {r11}

     ldr r10, =irq_save_r11
     str r11, [r10]
.endm

.macro irqrestore_regs
     ldr r0, =irq_save_r0
     ldr r0, [r0]
     ldr r1, =irq_save_r1
     ldr r1, [r1]
     ldr r2, =irq_save_r2
     ldr r2, [r2]
     ldr r3, =irq_save_r3
     ldr r3, [r3]
     ldr r4, =irq_save_r4
     ldr r4, [r4]
     ldr r5, =irq_save_r5
     ldr r5, [r5]
     ldr r6, =irq_save_r6
     ldr r6, [r6]
     ldr r7, =irq_save_r7
     ldr r7, [r7]
     ldr r8, =irq_save_r8
     ldr r8, [r8]
     ldr r9, =irq_save_r9
     ldr r9, [r9]
     ldr r10, =irq_save_r10
     ldr r10, [r10]
     ldr r11, =irq_save_r11
     ldr r11, [r11]
     ldr r12, =irq_save_r12
     ldr r12, [r12]
.endm

.equ Mode_IRQ, 0x12
.equ Mode_SVC, 0x13
.equ I_Bit, 0x80
.equ F_Bit, 0x40
.equ CPSRIRQ, (Mode_IRQ | I_Bit | F_Bit)
.equ CPSRSVC, (Mode_SVC | I_Bit | F_Bit)

.macro drop_to_irq_mode
    msr CPSR_c, #CPSRIRQ
.endm

.macro rise_to_svc_mode
    msr CPSR_c, #CPSRSVC
.endm

.balign 16
fault_irq:
    # begin save
    irqsave_regs

    rise_to_svc_mode
    mov r0, sp
    mov r1, r14
    drop_to_irq_mode

    # store LR_irq & SP_irq
    ldr r2, =irq_save_r13
    ldr r3, =irq_save_r14
    str r0, [r2]
    str r1, [r3]
    # end save

    ldr r0, =irq_save_r14_irq
    str r14, [r0]

    bl irq_hub

    # begin restore
    ldr r0, =irq_save_r13
    ldr r0, [r0]
    ldr r1, =irq_save_r14
    ldr r1, [r1]

    rise_to_svc_mode
    mov sp, r0
    mov lr, r1
    drop_to_irq_mode

    ldr r14, =irq_save_r14_irq
    ldr r14, [r14]

    irqrestore_regs
    # end restore

    # return
    subs pc, lr, #4

fault_fiq:
    ldr r0, =fault_fiq_str
    bl uart_send_string
    1: b 1b

.globl ivt_init
ivt_init:
  push {r0-r7, r10, r11}
  ldr r10, =ivt_table_precopy
  ldr r11, =0x00000000
  ldmia r10!, {r0-r7}
  stmia r11!, {r0-r7}
  ldmia r10,  {r0-r7}
  stmia r11,  {r0-r7}
  pop {r0-r7, r10, r11}
  mov pc, lr

.balign 16
ivt_table_precopy:
  fa: ldr pc, [pc, #0x18]
  fb1: ldr pc, [pc, #0x18]
  fb2: ldr pc, [pc, #0x18]
  fb3: ldr pc, [pc, #0x18]
  fb4: ldr pc, [pc, #0x18]
  fb5: ldr pc, [pc, #0x18]
  fb6: ldr pc, [pc, #0x18]
  fb7: ldr pc, [pc, #0x18]
  f1: .word fault_reset
  f2: .word fault_undefined
  f3: .word fault_swi
  f4: .word fault_prefetch_abort
  f6: .word fault_data_abort
  f7: .word fault_reserved
  f8: .word fault_irq
  f9: .word fault_fiq
