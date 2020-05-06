//****************************************
// Switch Life meter and Map in HUD
//****************************************

// WARNING: THIS HACK MODIFIES CODE FROM AUTOMAP
// This hack NEEDS to be included/compiled AFTER automap.asm to work properly
// To compile it properly, you need to have your main.asm hack like follows:
// incsrc automap.asm
// incsrc move_maps.asm
// Otherwise, this patch won't work properly

bank 6;
// PPU transfers for Automap tiles in the HUD and Subscreen
org $934F	// $1935F
	db $20,$76,$08,$30,$31,$32,$33,$34,$35,$36,$37
	db $20,$96,$08,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
	db $20,$B6,$08,$40,$41,$42,$43,$44,$45,$46,$47
	db $20,$D6,$08,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F 
	db $FF

org $A00E	// $1A01E
// Repoint the subscreen palette mappings for the new Automap tiles
	dw overworld_attributes	// F0 BE (Pointer to $BEF0) - Originally D3 A2 (Pointer to $A2D3 or $1A2E3 in PC)

org $A07E	// $1A08E
// Repoint attribute and tilemaps for Dungeon maps
	dw dungeon_attributes	// db $D3,$A2 - For original Automap tilemap	

org $A2CD	// $1A2DD
dungeon_attributes:
	db $23,$C0,$10		// PPU Transfer $23C0
	db $44,$55,$55,$00,$00,$00,$00,$40	// Attribute table for HUD
	db $44,$55,$05,$00,$00,$00,$00,$04	// Attribute table for HUD
// Move LIFE text to the left side of the HUD
	db $20,$63,$12		// PPU Transfer to $206F
	db "-LIFE-",$24,$24,$24,$24,$24,$24,$69,"B",$6B,$69,"A",$6B	// Tiles for item rectangles, B/A and -LIFE-
// FOLLOWING CODE MUST BE INCLUDED SO AUTOMAP WORKS PROPERLY
	db $20,$CF,$06		// PPU Transfer to $20CF
	db $6E,$6A,$6D,$6E,$6A,$6D	// Tiles for the bottom of the HUD rectangles
	db $20,$8F,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$91,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$92,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$94,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$6B,$84,{RUPEE},{ARROW},{KEY},{BOMB},$FF	// PPU Transfer for Rupee, (Empty), Key and Bomb icons in HUD (Jumps 0x20 in PPU per icon)
	db $29,$84,$09		// PPU Transfer to $2984
	db "INVENTORY"	// Tiles for "INVENTORY"
	db $FF

org $BEF0	// $1BF00
// HUD attribute table
overworld_attributes:
	db $23,$C0,$10		// PPU Transfer $23C0
	db $44,$55,$55,$00,$00,$C0,$FF,$70	// Attribute table for HUD
	db $44,$55,$05,$00,$00,$CC,$FF,$37	// Attribute table for HUD
// Move LIFE text to the left side of the HUD
	db $20,$63,$12		// PPU Transfer to $206F
	db "-LIFE-",$24,$24,$24,$24,$24,$24,$69,"B",$6B,$69,"A",$6B	// Tiles for item rectangles, B/A and -LIFE-
// FOLLOWING CODE MUST BE INCLUDED SO AUTOMAP WORKS PROPERLY
	db $20,$CF,$06		// PPU Transfer to $20CF
	db $6E,$6A,$6D,$6E,$6A,$6D	// Tiles for the bottom of the HUD rectangles
	db $20,$8F,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$91,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$92,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$94,$C2,$6C	// PPU Transfer for side lines of HUD rectangles
	db $20,$6B,$84,{RUPEE},{ARROW},{KEY},{BOMB},$FF	// PPU Transfer for Rupee, (Empty), Key and Bomb icons in HUD (Jumps 0x20 in PPU per icon)
	db $29,$84,$09		// PPU Transfer to $2984
	db "INVENTORY"	// Tiles for "INVENTORY"
	db $FF


//*************************************
// Map layouts
//*************************************

// Sprite dot offset in Maps

// Overworld Link dot offset
// CPU $93CE X offset for map sprite	PRG $1932E (00 > A0)
// This offset is shared between 1st and 2nd Quest overworld maps
org $932E  // $1933E
	db $A0
org $992D
	db $10


// DUNGEONS \\
// $254 aabbccdd Link's position on Map
// $258 aabbccdd Boss/Triforce position on Map

// aa=Ypos
// bb=Tile
// cc=Palette
// dd=Xpos

// Offset for Link's map dot sprite is the same as Boss/Triforce. 
// In addition to offset it more in Xpos there is an ADC $00.
// Table offset to each other are $FC for fast navigation.

// 1ST QUEST DOTS \\
// Lvl 1
// CPU $71F3 Y offset for map sprite	PRG $6A63
// CPU $6BAC X offset for map sprite 	PRG $1942A (00 > A0)
org $942A	// $1943A
	db $A0
// Lvl 2 PRG $19526 B0 > 50
org $9526	// $19536
	db $50
// Lvl 3 PRG $19622 C0 > 60
org $9622	// $19632
	db $60
// Lvl 4 PRG $1971e 10 > B0
org $971E	// $1972E
	db $B0
// Lvl 5 PRG $1981a F0 > 90
org $981A	// $1982A
	db $90
//Lvl 6 PRG $19916 C8 > 68
org $9916	// $19926
	db $68
// Lvl 7 PRG $19A12 C8 > 68 
org $9A12	// $19A22
	db $68
// Lvl 8 PRG $19B0E B0 > 50 
org $9B0E	// $19B1E
	db $50
// Lvl 9 PRG $19C0A 00 > A0 
org $9C0A	// $19C1A
	db $A0


// 2ND QUEST DOTS
// Lvl 1 PRG $18174 (E0 > 80)
org $8174	// $18164
	db $80
// Lvl 2 PRG $181AD 00 > A0
org $81E4	// $181F4
	db $68
// Lvl 3 PRG $181E4 C8 > 68
org $81AD	// $181BD
	db $A0
// Lvl 4 PRG $18221 10 > B0
org $825A	// $1826A
	db $50
// Lvl 5 PRG $1825A B0 > 50
org $8221	// $18231
	db $B0
// Lvl 6 PRG $1829D 00 > A0
org $829D	// $182AD
	db $A0
// Lvl 7 PRG $182DD C0 > 60 
org $82DD	// $182ED
	db $60
// Lvl 8 PRG $19B0E C0 > 60 
org $831C	// $1832C
	db $60
// Lvl 9 PRG $19C0A 00 > A0 
org $835F	// $1836F
	db $A0

// PRG 18000 Table for what level you enter. Of base $16 Lvl 1 $18, Lvl 2 ... $26 Lvl 9
// INFO: Some db tables are bigger and have different dungeon properties. 
// After the dot map is Link's entrance for the dungeon to make an example. 
// To-do: Describe Tables
//*************************************


// LEVEL-X text
org $9D04	// $19D14
	db $20,$56,$07
	db "LEVEL-0"
	db $FF

// 1ST QUEST \\
// Map for Level 1 - 1st Quest
org $944B	// $1945B
	db $20,$98,$05,$67,$FF,$24,$FB,$FB
	db $20,$B7,$05,$67,$FF,$FF,$FF,$67
	db $20,$D8,$03,$FB,$FF,$FB
	db $FF
// Map for Level 2 - 1st Quest
org $9547	// $19557
	db $20,$79,$03,$67,$FF,$FB 
	db $20,$9A,$02,$FF,$FF
	db $20,$BA,$02,$FF,$FF
	db $20,$D8,$04,$67,$FF,$FF,$67
	db $FF
// Map for Level 3 - 1st Quest
org $9643	// $19653
	db $20,$98,$04,$67,$FF,$24,$FB
	db $20,$B7,$05,$FF,$FF,$FF,$FF,$FF
	db $20,$D7,$04,$67,$24,$FF,$FB
// Map for Level 4 - 1st Quest
org $973F	// $1974F
	db $20,$78,$04,$FF,$67,$FF,$FF
	db $20,$98,$03,$FF,$FF,$FB
	db $20,$B8,$02,$FF,$FB
	db $20,$D8,$03,$FB,$FF,$67
// Map for Level 5 - 1st Quest
org $983B	// $1984B
	db $20,$78,$04,$FB,$67,$FF,$FB
	db $20,$98,$04,$FF,$67,$67,$FF
	db $20,$B9,$03,$FB,$FF,$FF
	db $20,$D8,$04,$67,$67,$FF,$FF
// Map for Level 6 - 1st Quest
org $9937	// $19947
	db $20,$77,$06,$FB,$FF,$FF,$FF,$FF,$FB
	db $20,$97,$06,$FF,$FF,$FB,$24,$FF,$67
	db $20,$B7,$01,$FF
	db $20,$D7,$03,$FF,$FB,$FF
// Map for Level 7 - 1st Quest
org $9A33	// $19A43
	db $20,$77,$06,$FB,$FF,$67,$FF,$FF,$67
	db $20,$97,$04,$FF,$FF,$FF,$67
	db $20,$B7,$04,$FF,$FF,$FB,$FB
	db $20,$D7,$06,$FF,$FF,$FF,$67,$67,$67
// Map for Level 8 - 1st Quest
org $9B2F	// $19B3F
	db $20,$79,$03,$FB,$FF,$FB
	db $20,$97,$05,$FB,$FF,$FB,$FF,$FB
	db $20,$B7,$05,$67,$FF,$FF,$FF,$FB
	db $20,$D8,$04,$FB,$FB,$FF,$FB
// Map for Level 9 - 1st Quest
org $9C2B	// $19C3B
	db $20,$76,$08,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FB
	db $20,$96,$08,$FF,$FF,$67,$FF,$FF,$67,$FF,$FF
	db $20,$B6,$48,$FF
	db $20,$D7,$06,$FF,$67,$FF,$FF,$67,$FF

// 2ND QUEST \\
// Map for Level 1 - 2nd Quest
org $8195	// $181A5
	db $20,$79,$42,$FF
	db $20,$99,$02,$FF,$FB
	db $20,$B9,$02,$FF,$67
	db $20,$D9,$42,$FF
	db $FF
// Map for Level 2 - 2nd Quest
org $8205	// $18215
	db $20,$78,$03,$FB,$FF,$FB
	db $20,$98,$03,$FF,$67,$FF
	db $20,$B8,$43,$FF
	db $20,$D8,$03,$FF,$24,$FF
	db $FF
// Map for Level 3 - 2nd Quest
org $81CE	// $181DE
	db $20,$7B,$01,$FB
	db $20,$96,$01,$FF
	db $20,$9B,$C3,$FF
	db $20,$DC,$01,$FF
	db $FF
// Map for Level 4 - 2nd Quest
org $827B	// $1828B
	db $20,$78,$04,$FF,$FF,$FF,$FB
	db $20,$98,$04,$FF,$FF,$67,$FF
	db $20,$B8,$04,$FF,$FF,$FB,$FF
	db $20,$D8,$04,$FF,$FF,$FF,$67
	db $FF
// Map for Level 5 - 2nd Quest
org $8242	// $18252
	db $20,$78,$43,$FF
	db $20,$99,$02,$FB,$FF
	db $20,$B8,$02,$FF,$67
	db $20,$D8,$43,$FF
	db $FF
// Map for Level 6 - 2nd Quest
org $82BE	// $182CE
	db $20,$79,$03,$FB,$FF,$67
	db $20,$7C,$C2,$FF
	db $20,$9A,$C3,$FF
	db $20,$99,$83,$FF,$FF,$67
	db $20,$B7,$02,$FB,$FF
	db $FF
// Map for Level 7 - 2nd Quest
org $82FE	// $1830E
	db $20,$76,$C3,$FF
	db $20,$77,$C3,$FF
	db $20,$78,$45,$67
	db $20,$7D,$C4,$FF
	db $20,$9B,$C2,$FF
	db $20,$D6,$46,$67
	db $FF
// Map for Level 8 - 2nd Quest
org $833D	// $1834D
	db $20,$78,$45,$FB
	db $20,$98,$05,$FF,$FB,$FB,$24,$FF
	db $20,$B8,$43,$FF
	db $20,$BC,$01,$FF
	db $20,$D6,$46,$FB
	db $20,$DC,$01,$FF
	db $FF
// Map for Level 9 - 2nd Quest
org $8380	// $18390
	db $20,$76,$48,$FF
	db $20,$78,$44,$FB
	db $20,$97,$46,$FB
	db $20,$98,$44,$FF
	db $20,$B6,$08,$FF,$FF,$FB,$FF,$FF,$FB,$FF,$FF
	db $20,$D7,$46,$67
	db $20,$D9,$42,$FF
	db $FF



//**************
// Life meter
//**************

bank 5;
// Move HEARTS to the Left of the HUD
org $AC70	// $16C80
	db $20,$82,$08	// PPU transfer to $20D6
	db $24,$24,$24,$24,$24,$24,$24,$24
	db $20,$A2,$08	// PPU transfer to $20B6
	db $24,$24,$24,$24,$24,$24,$24,$24
