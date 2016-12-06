# waccOS central makefile, the great dispatch
TRIPLET=arm-none-eabi-

CC=$(TRIPLET)gcc
CFLAGS=-ffreestanding -nostdlib -nostartfiles

LD=$(TRIPLET)gcc
LDFLAGS=-ffreestanding -nostdlib -nostartfiles

AS=$(TRIPLET)gcc
ASFLAGS=-fPIC -mcpu=arm1176jzf-s -ffreestanding

WACC=wacc-exe
WACCFLAGS=-Iinclude -q

OBJCOPY=$(TRIPLET)objcopy

LNKSCR=linker.ld
TARGET=waccos.elf
RAW=waccos.img

# kaboom

SRCS=$(wildcard boot/*.S)
SRCS+=$(wildcard drivers/*.S)
SRCS+=$(wildcard arch/*.S)
SRCS+=$(wildcard kernel/*.S)
SRCS+=$(wildcard mm/*.S)
SRCS+=$(wildcard util/*.S)
SRCS+=$(wildcard fs/ext2/*.wacc)
SRCS+=$(wildcard drivers/*.wacc)
SRCS+=$(wildcard kernel/*.wacc)
SRCS+=$(wildcard lib/*.wacc)
SRCS+=$(wildcard mm/*.wacc)
SRCS+=$(wildcard util/*.wacc)
SRCS+=$(wildcard fs/*.S)

OBJS=$(patsubst %.wacc,%.o,$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SRCS))))
WACC_AS=$(patsubst %.wacc,%.S,$(filter %.wacc,SRCS))

.SUFFIXES:

all: $(RAW)

clean:
	-@rm $(OBJS) >/dev/null 2>&1
	-@rm $(TARGET) >/dev/null 2>&1
	-@rm $(WACC_AS) >/dev/null 2>&1

$(TARGET): $(WACC_AS) $(OBJS)
	@echo "  LD           $@"
	@$(LD) $(LDFLAGS) -T $(LNKSCR) -o $(TARGET) $(OBJS) -lgcc

$(RAW): $(TARGET)
	@echo "  OBJCOPY      $@"
	@$(OBJCOPY) $(TARGET) -O binary $(RAW)

%.o: %.S
	@echo "  AS           $@"
	@$(AS) $(ASFLAGS) -c $< -o $@

%.o: %.c
	@echo "  CC           $@"
	@$(CC) $(CFLAGS) -c $< -o $@

%.S: %.wacc
	@echo "  WACC-AS      $@"
	@$(WACC) $(WACCFLAGS) $<

.PHONY: all clean
