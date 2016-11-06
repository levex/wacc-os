ENTRY(_start)
SECTIONS
{
	/* raspi loads us to 0x8000 */
        . = 0x8000;
	_text_start = .;
	.text :
	{
		KEEP(*(.text))
	}
	_text_end = .;
	. = ALIGN(4096);
	_data_start = .;
	.data :
	{
		KEEP(*(.data))
	}
	_data_end = .;
}
