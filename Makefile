# waccOS central makefile, the great dispatch
TRIPLET=arm-none-eabi-

CC=$(TRIPLET)gcc
CFLAGS=-ffreestanding -nostdlib

LD=$(TRIPLET)ld
LDFLAGS=

AS=$(TRIPLET)as
ASFLAGS=

WACC=wacc-exe
WACCFLAGS=-I include

LNKSCR=linker.ld
TARGET=waccos.img

# kaboom

SRCS=$(wildcard boot/*.S)
SRCS+=$(wildcard drivers/*.S)
SRCS+=$(wildcard util/*.S)
SRCS+=$(wildcard drivers/*.wacc)
SRCS+=$(wildcard kernel/*.wacc)

OBJS=$(patsubst %.wacc,%.o,$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(SRCS))))
WACC_AS=$(patsubst %.wacc,%.S,$(filter %.wacc,SRCS))

all: $(TARGET)

clean:
	-@rm $(OBJS) >/dev/null 2>&1
	-@rm $(TARGET) >/dev/null 2>&1
	-@rm $(WACC_AS) >/dev/null 2>&1

$(TARGET): $(WACC_AS) $(OBJS)
	@echo "  LD           $@"
	@$(LD) $(LDFLAGS) -T $(LNKSCR) -o $(TARGET) $(OBJS)

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
