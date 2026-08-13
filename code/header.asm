;----------------------------------------
;		iNES Header
;----------------------------------------

; Header taken originally from "animate.asm"
%org($8000-$10,0)
Internal_Rom_Header:
{
	db "NES",$1A	; Identification string "NES<EOF>"
	;db $4E,$45,$53,$1A	// Header (NES $1A)
	db $08			; 8 x 16k PRG banks, PRG size
	db $00			; 0 x 8k CHR banks, CHR size
	
	db %00010010	; Flags ($12)
	;------------
	;   NNNNFTBM
	;   |||||||+-- Hard-wired nametable mirroring type
	;   |||||||	0: Horizontal (vertical arrangement) or mapper-controlled
	;   |||||||	1: Vertical (horizontal arrangement)
	;   ||||||+--- "Battery" and other non-volatile memory
	;   ||||||	0: Not present
	;   ||||||	1: Present
	;   |||||+---- 512-byte Trainer
	;   |||||	0: Not present
	;   |||||	1: Present between Header and PRG-ROM data
	;   ||||+----- Hard-wired four-screen mode
	;   ||||	0: No
	;   ||||	1: Yes
	;   ++++------ Mapper Number D0..D3
	
	db %00001000	; Flags ($00)
	;------------
	;   NNNN10TT
	;   ||||||++-- Console type
	;   ||||||	0: Nintendo Entertainment System/Family Computer
	;   ||||||	1: Nintendo Vs. System
	;   ||||||	2: Nintendo Playchoice 10
	;   ||||||	3: Extended Console Type
	;   ||||++---- NES 2.0 identifier
	;   ++++------ Mapper Number D4..D7
	
	db %00000000	; Mapper MSB/Submapper ($00)
	;------------
	;   SSSSNNNN
	;   ||||++++-- Mapper number D8..D11
	;   ++++------ Submapper number
	
	db %00000000	; PRG-ROM/CHR-ROM size MSB ($00)
	;------------
	;   CCCCPPPP
	;   ||||++++-- PRG-ROM size MSB
	;   ++++------ CHR-ROM size MSB
	
	db %01110000	; PRG-RAM/EEPROM size ($00)
	;------------
	;   ppppPPPP
	;   |||| ++++- PRG-RAM (volatile) shift count
	;   ++++------ PRG-NVRAM/EEPROM (non-volatile) shift count
	; If the shift count is zero, there is no PRG-(NV)RAM.
	; If the shift count is non-zero, the actual size is
	; "64 << shift count" bytes, i.e. 8192 bytes for a shift count of 7.

	db %00001001	; CHR-RAM size ($00)
	;------------
	;   ccccCCCC
	;   |||| ++++- CHR-RAM size (volatile) shift count
	;   ++++------ CHR-NVRAM size (non-volatile) shift count
	; If the shift count is zero, there is no CHR-(NV)RAM.
	; If the shift count is non-zero, the actual size is
	; "64 << shift count" bytes, i.e. 8192 bytes for a shift count of 7.

	db %000000000	; CPU/PPU Timing ($00)
	;------------
	;   ......vv
	;	  ++- CPU/PPU timing mode
	;		0: RP2C02 ("NTSC NES")
	;		1: RP2C07 ("Licensed PAL NES")
	;		2: Multiple-region
	;		3: UA6538 ("Dendy")

	db %00000000	; ($00)
	; When Byte 7 AND 3 =1: Vs. System Type
	;------------
	;   MMMMPPPP
	;   |||| ++++- Vs. PPU Type
	;   ++++------ Vs. Hardware Type
	; When Byte 7 AND 3 =3: Extended Console Type
	;------------
	;   ....CCCC
	;	++++- Extended Console Type

	db %00000000	; ($00)
	;------------
	;   ......RR
	;	  ++- Number of miscellaneous ROMs present

	db %00000000	; ($00)
	;------------
	;   ..DDDDDD
	;     ++++++- Default Expansion Device
}
