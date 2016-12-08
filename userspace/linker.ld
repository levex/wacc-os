ENTRY(_start)
SECTIONS
{
	/* waccOS constraint @TODO */
	. = 0xA000000;
	.text :
	{
		KEEP(*(.text))
	}
	.data :
	{
		KEEP(*(.data))
	}
}
