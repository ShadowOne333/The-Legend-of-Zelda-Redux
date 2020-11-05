///***********************************************************
//	File Selection screen changes
//************************************************************

// PPU transfer, move "NAME" in the Save Screen one tile to the left
bank 6;
org $A148	// 0x1A158
	db $21,$09,$06	// Originally 21 0A 06


// Flip heart rows in the File Select Screen AND in-game:
bank 1;
org $A70B	// 0x0671B
	adc.b #$12	// Originally ADC #$07
org $A718	// 0x06728
	adc.b #$07	// Originally ADC #$12

bank 5;
org $AC70	// 0x16C80
	db $20,$82,$08	// Originally 20 A2 08
org $AC7C	// 0x16C8C
	db $20,$A2,$08


// Change all of the "-" that use $62 as their Hex to $2F (to free up one tile)
bank 1;
org $87BD	// 0x047CD - Dash used for shops and secret caves
	ldx.b #$2F	// Originally LDX #$62
org $89E6	// 0x049F6 - "+" symbol used for the Money-Making games
	ldx.b #$2B	// Originally LDX #$64
org $89F0	// 0x04A00 - Dash used for the Money-Making games
	ldx.b #$2F	// Originally LDX #$62

bank 2;
org $9DCD	// 0x09DDD - Elimination Mode Character detection
	db $2F,$2C	// Dash, Dot (Register Your Name input)
org $9DD3	// 0x09DE3 - Elimination mode character detection
	db $2E		// Question mark (Register Your Name input)
org $A25F	// 0x0A26F - File Select File dashes
	db $2F
org $AD9D	// 0x0ADAD - 2nd Quest Ending dash
	db $2F

bank 6;
org $9D0C	// 0x19D1C - Dash for "LEVEL-X" in Dungeons
	db $2F
org $A119	// 0x1A129 - First dash for "-SELECT-"
	db $2F
org $A127	// 0x1A137 - Second dash for "-SELECT-"
	db $2F
org $A1DE	// 0x1A1EE - Dash character for Register Name
	db $2F
org $A1E0	// 0x1A1F0 - Dot character for Register Name
	db $2C
org $A1EA	// 0x1A1FA - Change dot character for question mark in Register Name
	db $2E
org $A2A1 	// 0x1A2B1 - UNKNOWN - PPU transfer for something like "-100"?
	db $2F
org $A2A9	// 0x1A2B9 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2B0	// 0x1A2C0 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2EF	// 0x1A2FF - First dash for "-LIFE-" 
	db $2F
org $A2F4	// 0x1A304 - Second dash for "-LIFE-'
	db $2F
// Following two changes are included in automap.asm
//org $BF0E	// 0x1BF1E - First dash for "-LIFE-" 
//	db $2F
//org $BF13	// 0x1BF23 - Second dash for "-LIFE-"
//	db $2F


// Change palette of Link on File Select screen
bank 6; org $9CEB	// 0x19CFB
	db $0F,$29,$27,$17	// Black, green, beige, brown
	db $0F,$22,$27,$17	// Black, blue, beige, brown
	db $0F,$16,$27,$17	// Black, red, beige, brown


// Change palette for the Inner Heart in Elimination Mode
bank 2; org $9EB0	// 0x09EC0
	lda.b #$02	// Originally A9 30 (LDA #$30)


