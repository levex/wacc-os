.section ".data"

.globl ext2_disk_image
.globl _ext2_disk_end
.balign 16
ext2_disk_image:
	.incbin "disk.img"
_ext2_disk_end: .word 0x13371337
