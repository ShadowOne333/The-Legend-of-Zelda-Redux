//***********************************************************
//	Zelda 1 Intro Story Text
//***********************************************************

//****************************************
//	Table file
//****************************************
table code/text/text.tbl,ltr

//****************************************
//	Control codes
//****************************************
define	end	$FF  // end


//***********************************************************
//	Introduction Text
//***********************************************************
bank 6; 
org $A48F	// 0x1A49F
	db "#<# THE LEGEND OF ZELDA #<>#"
org $A4FA	// 0x1A50A
	db "LONG AGO, GANON, PRINCE  "
org $A540	// 0x1A550
	db "OF DARKNESS, STOLE THE   "
org $A586	// 0x1A596
	db "TRIFORCE OF POWER.       "
org $A5CC	// 0x1A5DC
	db "PRINCESS ZELDA OF HYRULE "
org $A612	// 0x1A622
	db "BROKE THE TRIFORCE OF    "
org $A658	// 0x1A668
	db "WISDOM INTO 8 PIECES AND "
org $A69E	// 0x1A6AE
	db "HID THEM FROM GANON      "
org $A6E4	// 0x1A6F4
	db "BEFORE SHE WAS KIDNAPPED "
org $A72A	// 0x1A73A
	db "BY HIS MINIONS.          "
org $A770	// 0x1A780
	db " LINK, FIND THE 8 PIECES "
org $A7B6	// 0x1A7C6
	db "    AND RESCUE ZELDA.    "

// Empty spaces to clean up the quotation marks from the Story text
org $A4D6	// 0x1A4E6
	db "                          "
org $A51C	// 0x1A52C
	db "                          "
org $A562	// 0x1A572
	db "                          "
org $A5A8	// 0x1A5B8
	db "                          "
org $A5EE	// 0x1A5FE
	db "                          "
org $A634	// 0x1A644
	db "                          "
org $A67A	// 0x1A68A
	db "                          "
org $A6C0	// 0x1A6D0
	db "                          "
org $A706	// 0x1A716
	db "                          "
org $A74C	// 0x1A75C
	db "                          "
org $A792	// 0x1A7A2
	db "                          "
org $A7D8	// 0x1A7E8
	db "                          "


//***********************************************************
//	Introduction Text Attribute Table
//***********************************************************

// Introduction text attribute table
// ———————————————
org $A818	// 0x1A828
	db $23,$C0,$20	// PPU transfer
	db $FF,$FF,$00,$00,$00,$00,$FF,$FF  // THE LEGEND OF ZELDA
	db $FF,$0B,$0A,$8A,$AA,$0A,$0E,$FF  // Long ago, Ganon, Prince of Darkness, stole the
	db $FF,$A0,$A0,$A0,$A0,$A0,$00,$FF  // Triforce of Power. Princess Zelda of Hyrule
	db $FF,$05,$05,$45,$51,$50,$50,$FF  // Broke the Triforce of Wisdom into 8 pieces and

	db $23,$E0,$20	// PPU transfer
	db $FF,$05,$01,$00,$81,$A0,$00,$FF  // Hid them from Ganon before she was kidnapped
	db $FF,$00,$00,$00,$00,$80,$A0,$FF  // by his minions. Link, find the 8 pieces
	db $FF,$AF,$AB,$AA,$6A,$59,$2A,$FF  // and rescue Zelda.
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  // 


// List of Treasures attribute table
// ———————————————
	db $2B,$D0,$02
	db $FF,$FF

	db $2B,$D6,$02
	db $FF,$FF

// Terminator
	db $FF


//***********************************************************
//	Remove Automap text from title screen
//***********************************************************

org $A8B4	// 0x1A8C4
	db "                     "


//***********************************************************
//	Treasures text pointers
//***********************************************************

bank 2; 
org $94AD	// 0x094BD
	dw treasure_00, treasure_01, treasure_02, treasure_03
	dw treasure_04, treasure_05, treasure_06, treasure_07
	dw treasure_08, treasure_09, treasure_10, treasure_11
	dw treasure_12, treasure_13, treasure_14, treasure_15
	dw treasure_16, treasure_17, treasure_18, treasure_19
	dw treasure_20, treasure_21, treasure_22, treasure_23
	dw treasure_24, treasure_25, treasure_26, treasure_27
	dw treasure_28


//***********************************************************
//	Treasure List
//***********************************************************

org $929A	// 0x092AA
//----------------------------------------
treasure_00:
	// X Position, "Text"
	db $00, "<><><>#  LIST OF ITEMS  #<><><><",{end}
//00 E5 E4 E5 E4 E5 E6 24 15 12 1C 1D 24 18 0F 24 1D 1B 0E 0A 1C 1E 1B 0E 1C 24 E6 E4 E5 E4 E5 E4 E5 FF
//----------------------------------------
treasure_01:
	db $07, "HEART        HEART",{end}
//07 11 0E 0A 1B 1D 24 24 24 24 24 24 24 24 11 0E 0A 1B 1D 24 FF
//----------------------------------------
treasure_02:
	db $12, "CONTAINER",{end}
//12 0C 18 17 1D 0A 12 17 0E 1B FF
//----------------------------------------
treasure_03:
	db $07, "FAIRY        CLOCK",{end}
//07 0F 0A 12 1B 22 24 24 24 24 24 24 24 24 0C 15 18 0C 14 FF
//----------------------------------------
treasure_04:
	db $07, "RUPEE      5 RUPEES",{end}
//07 1B 1E 19 0E 0E 24 24 24 24 24 24 05 24 1B 1E 19 0E 0E 1C FF
//----------------------------------------
treasure_05:
	db $04, "BLUE POTION   RED POTION",{end}
//04 15 12 0F 0E 24 19 18 1D 12 18 17 24 24 24 1B 0E 0D 24 19 18 1D 12 18 17 FF
//----------------------------------------
treasure_06:
	db $06, "LETTER        BAIT",{end}
//06 15 0E 1D 1D 0E 1B 24 24 24 24 24 24 24 24 0B 0A 12 1D FF
//----------------------------------------
treasure_07:
	db $07, "SWORD        WHITE",{end}
//07 1C 20 18 1B 0D 24 24 24 24 24 24 24 24 20 11 12 1D 0E FF
//----------------------------------------
treasure_08:
	db $14, "SWORD",{end}
//14 1C 20 18 1B 0D FF
//----------------------------------------
treasure_09:
	db $06, "MAGICAL      MAGICAL",{end}
//06 16 0A 10 12 0C 0A 15 24 24 24 24 24 24 16 0A 10 12 0C 0A 15 FF
//----------------------------------------
treasure_10:
	db $07, "SWORD        SHIELD",{end}
//07 1C 20 18 1B 0D 24 24 24 24 24 24 24 24 1C 11 12 0E 15 0D FF
//----------------------------------------
treasure_11:
	db $05, "BOOMERANG     MAGICAL",{end}
//05 0B 18 18 16 0E 1B 0A 17 10 24 24 24 24 24 16 0A 10 12 0C 0A 15 FF
//----------------------------------------
treasure_12:
	db $12, "BOOMERANG",{end}
//12 0B 18 18 16 0E 1B 0A 17 10 FF
//----------------------------------------
treasure_13:
	db $07, "BOMB          BOW",{end}
//07 0B 18 16 0B 24 24 24 24 24 24 24 24 24 24 0B 18 20 FF
//----------------------------------------
treasure_14:
	db $07, "ARROW        SILVER",{end}
//07 0A 1B 1B 18 20 24 24 24 24 24 24 24 24 1C 12 15 1F 0E 1B FF
//----------------------------------------
treasure_15:
	db $14, "ARROW",{end}
//14 0A 1B 1B 18 20 FF
//----------------------------------------
treasure_16:
	db $07, "BLUE          RED",{end}
//07 0B 15 1E 0E 24 24 24 24 24 24 24 24 24 24 1B 0E 0D FF
//----------------------------------------
treasure_17:
	db $06, "CANDLE        CANDLE",{end}
//06 0C 0A 17 0D 15 0E 24 24 24 24 24 24 24 24 0C 0A 17 0D 15 0E FF
//----------------------------------------
treasure_18:
	db $04, "BLUE TUNIC    RED TUNIC",{end}
//05 0B 15 1E 0E 24 1B 12 17 10 24 24 24 24 24 1B 0E 0D 24 1B 12 17 10 FF
//----------------------------------------
treasure_19:
	db $07, "         ",{end}	// Empty
//07 24 24 24 24 24 24 24 24 24 FF
//----------------------------------------
treasure_20:
	db $07, "POWER        FLUTE  ",{end}
//07 19 18 20 0E 1B 24 24 24 24 24 24 24 24 0F 15 1E 1D 0E 24 24 FF
//----------------------------------------
treasure_21:
	db $05, "BRACELET",{end}
//05 0B 1B 0A 0C 0E 15 0E 1D FF
//----------------------------------------
treasure_22:
	db $07, "RAFT       STEPLADDER",{end}
//07 1B 0A 0F 1D 24 24 24 24 24 24 24 1C 1D 0E 19 15 0A 0D 0D 0E 1B FF
//----------------------------------------
treasure_23:
	db $06, "MAGICAL      BOOK OF",{end}
//06 16 0A 10 12 0C 0A 15 24 24 24 24 24 24 0B 18 18 14 24 18 0F FF
//----------------------------------------
treasure_24:
	db $08, "ROD         MAGIC",{end}
//08 1B 18 0D 24 24 24 24 24 24 24 24 24 16 0A 10 12 0C FF
//----------------------------------------
treasure_25:
	db $08, "KEY        LION KEY",{end}
//08 14 0E 22 24 24 24 24 24 24 24 24 15 12 18 17 24 14 0E 22 FF
//----------------------------------------
treasure_26:
	db $15, "  ",{end}
//15 24 24 FF
//----------------------------------------
treasure_27:
	db $08, "MAP        COMPASS",{end}
//08 16 0A 19 24 24 24 24 24 24 24 24 0C 18 16 19 0A 1C 1C FF
//----------------------------------------
treasure_28:
	db $0C, "TRIFORCE",{end}
//0C 1D 1B 12 0F 18 1B 0C 0E FF
//----------------------------------------


