.section ".data"
// 256mb of RAM is 256*1024*1024 bytes
// divided by 4096 (size of page)
// divided by 8 (number of bits in a byte)
.balign 16
.globl frames
frames: .skip 8192

.balign 16
.globl nframes
nframes: .word 65536
