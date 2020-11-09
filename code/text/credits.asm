//***********************************************************
//	Zelda 1 Credits Text
//***********************************************************

//****************************************
// Table file
//****************************************
table code/text/text.tbl,ltr

//****************************************
// Control codes
//****************************************
define	nextline	$40	// Jump to next line
define	endline		$C0	// End line parsing
define	end		$FF 	// End

//***********************************************************
//	"Saving Zelda" text pointers
//***********************************************************
bank 2;
// Pointers for text that appears right after saving Zelda
org $A9B4	// 0x0A9C4
	lda.b #end_text1
	sta.b $00
	lda.b #end_text1>>8
	sta.b $01

// Horizontal starting position for "THANKS LINK..."
org $A94A	// 0x0A95A
	lda.b #$A6	// Originally LDA #$A4
// Horizontal starting position for "THE HERO..."
org $A992	// 0x0A9A2
	db $C4,$E7	// Originally C4 E4
//This is an LDA $AB67,Y (B9 07 AB in Hex starting at $AB56)
org $AB56	// 0x0AB66
	lda.w end_text2,y	// Originally LDA $AB07,Y
// The table here tells the game what position each character in the "PEACE RETURNS TO HYRULE" text is placed in the Credits
org $AB6C	// 0x0AB7C

	lda.w layout_text2,y	// Originally LDA $AAD3,Y

//***********************************************************
//	Credits roll text pointers
//***********************************************************

// The credits pointers are stored in a very odd way ($17 entries)
// For the first entry in the credits, "STAFF" located at $AC5C (or 0x0AC6C), the pointer is $AC5C.
// The 2 byte pointers are separated into two different addresses. The lower bytes for each pointer begin at $AC2E (or 0x0AC3E) with $5C. and the second/high byte of the pointers begin at $AC45 (or 0x0AC55) with $AC. The two bytes combined form the pointer for the "STAFF" text. Code related to the credits begins at $AE13.

bank 2;
// Credits roll low and high byte pointers tables
org $AE8A	// 0x0AE9A
// LDA for the pointer lower bytes table
	lda.w low_bytes,y	// LDA $AC2E,Y
org $AE8F	// 0x0AE9F
// LDA for the pointer lower bytes table
	lda.w high_bytes,y	// LDA $AC45,Y


// Pointer low byte for each entry
org $AC2E	// 0x0AC3E
low_bytes:
	db credits_00,credits_01,credits_02,credits_03
	db credits_04,credits_05,credits_06,credits_07
	db credits_08,credits_09,credits_10,credits_11
	db credits_12,credits_13,credits_14,credits_15
	db credits_16,credits_17,credits_18,credits_19
	db credits_20,credits_21,credits_22

// Pointer high byte for each entry
org $AC45	// 0x0AC55
high_bytes:
	db credits_00>>8,credits_01>>8,credits_02>>8,credits_03>>8
	db credits_04>>8,credits_05>>8,credits_06>>8,credits_07>>8
	db credits_08>>8,credits_09>>8,credits_10>>8,credits_11>>8
	db credits_12>>8,credits_13>>8,credits_14>>8,credits_15>>8
	db credits_16>>8,credits_17>>8,credits_18>>8,credits_19>>8
	db credits_20>>8,credits_21>>8,credits_22>>8


org $AC5C	// 0x0AC6C
// Blank out all of the original Credits text previous data (for extra free space in case it's needed). This gives 0x19E bytes of free space!
	fillto $ADFA,$FF

//***********************************************************
//   "Saving Zelda" 1st and 2nd text
//***********************************************************

// First text after saving Zelda
org $A860	// 0x0A870
// The table found here determines the position of each character in the 'end_text2' text table. Each value corresponds to each text character (one by one). If said text is extended (or shortened), so should this table to account for the new (or reduced) characters, as well as their position in the screen.

layout_text2:
// FINALLY,
	db $AC,$AD,$AE,$AF,$B0,$B1,$B2,$B3,$B4
// PEACE RETURNS TO HYRULE.
	db $E4,$E5,$E6,$E7,$E8,$E9,$EA,$EB,$EC,$ED,$EE,$EF,$F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7,$F8,$F9,$FA,$FB
// THIS ENDS THE STORY.
	db $4C,$4D,$4E,$4F,$50,$51,$52,$53

end_text1:	// $A8A0 - Originally $A959, 0x0A969
	db "THANKS, LINK, YOU'RE",	' '|{nextline}
	db "THE HERO OF HYRULE",	'!'|{endline}
// Second text after saving Zelda
end_text2:	// $A8C8 - Originally $AB07, 0x0AB17
	db "AND THUS,"			//24 0A 17 0D 24 1C 18 28
	db "PEACE RETURNS TO HYRULE."	//19 0E 0A 0C 0E 24 1B 0E 1D 1E 1B 17 1C 24 1D 18 24 11 22 1B 1E 15 0E 2C
	db "THE END.",{end}//24 24 24 24 FF
	fillto $A900,$FF

//***********************************************************
//  Credits Roll and Post-credits text
//***********************************************************

org $B050	// 0x0B060 - Originally $AC60, 0x0AC70
// Length, X Position, "Text"
// Hiroshi Yamauchi, Shigeru Miyamoto, Takashi Tezuka, Toshihiko Nakago, Yasunari Soejima, Tatsuo Nishiyama, Koji Kondo
credits_00:
	db $07,$0C," STAFF "			// STAFF
credits_01:
	db $13,$07,"EXECUTIVE PRODUCER:"	// Executive Producer:
credits_02:
	db $10,$08,"HIROSHI YAMAUCHI"		// Hiroshi Yamauchi
credits_03:
	db $16,$05,"PRODUCER... S.MIYAMOTO"	// Producer... Shigeru Miyamoto
credits_04:
	db $16,$05,"DIRECTOR... S.MIYAMOTO"	// Director... Shigeru Miyamoto
credits_05:
	db $0E,$09,"TAKASHI TEZUKA"		// ..... Takashi Tezuka
credits_06:
	db $16,$05,"DESIGNER..... T.TEZUKA"	// Designer... Toshihiko Nakago
credits_07:
	db $16,$05,"PROGRAMMER... T.NAKAGO"	// Programmer... Yasunari Soejima
credits_08:
	db $10,$08,"YASUNARI SOEJIMA"		// Yasunari Soejima
credits_09:
	db $10,$08,"TATSUO NISHIYAMA"		// Tatsuo Nishiyama
credits_10:
	db $0F,$09,"SOUND COMPOSER:"		// Sound Composer:
credits_11:
	db $0A,$0B,"KOJI KONDO"			// Koji Kondo

credits_12:
	db $18,$04,"ANOTHER QUEST WILL START"	// Another quest will start
credits_13:
	db $0A,$0B,"FROM HERE."			// from here.
credits_14:
	db $17,$05,"PRESS THE START BUTTON."	// Press the START button
credits_15:
	db $0E,$09,$FC,"1986 NINTENDO"		// (C)1986 Nintendo

credits_16:
	db $0E,$09,"YOU ARE GREAT!"		// You are great!
credits_17:
	db $0D,$09,"         -   "		// "         -   "
credits_18:
	db $13,$06,"YOU HAVE AN AMAZING"	// You have an amazing
credits_19:
	db $11,$08,"WISDOM AND POWER!"		// Wisdom and Power!
credits_20:
	db $07,$0C,"THE END"			// The End
credits_21:
	db $15,$05,$2D,"THE LEGEND OF ZELDA",$2D// "The Legend of Zelda"
credits_22:
	db $0E,$09,$FC,"1986 NINTENDO",{end}	// (C)1986 Nintendo


