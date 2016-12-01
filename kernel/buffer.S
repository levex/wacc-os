.section ".data"
.globl buffer
buffer: .skip 4096

// 256mb of RAM is 256*1024*1024 bytes
// divided by 4096 (size of page)
// divided by 8 (number of bits in a byte)
.globl frame_buffer
frame_buffer: .skip 8192
