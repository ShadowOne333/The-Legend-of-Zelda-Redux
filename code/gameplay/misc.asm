//****************************************************************
//	Miscellaneous hacks done to Zelda 1
//****************************************************************

//***********************************************************
//	Remove extra staircases
//***********************************************************

// Removes the extra staircases outside Level 5 and 6 (1st Quest) and outside a 30 rupees location (2nd Quest)
// The limitation of only one entrance per screen forces them to be just secondary entrances to the labyrinths no matter what, and if you exit the labyrinth when you have entered it from the secondary entrance, the walking on stairs animation is absent.
bank 4; org $8CBA	// 0x10CCA
	db $70,$B0,$70	// Originally B0 B0 30


//***********************************************************
//	Modify the Sword beam to stop firing at 3/4 hearts
//***********************************************************

bank 7; org $F879	// 0x1F889
// Default value of fire is at full hearts with damage above $80
// Change it to full hearts above $C0 for 1/4 hearts
// The Sword beam stops firing when it reaches 3/4 of the heart's gauge
	cmp.b #$C0	// Originally CMP #$80


//***********************************************************
//	Remove 1 Rupee flashing
//***********************************************************

// The color switch is 8 frames, and applies to a few objects, like small hearts, Triforce pieces, etc. I looked for all occurences of RAM $15, which is a frame counter. So, starting at 1E735, there's code that determines which items should be flashing. So replace this code with NOPs (EA):

bank 7; org $E73D	// 0x1E74D
	nop	// Originally CPX #$16
	nop	// Originally CPX #$16
	nop	// Originally BEQ $0C -> 1E74D
	nop	// Originally BEQ $0C -> 1E74D

// At 6B5C, there's a table with palette codes for various things. 
// Change value at 6B72 to make the rupee another color if you want.
// 00 - Link, 01 - Orange, 02 - Blue, 03 - Zora/Moblin
// bank 1; org $AB72	// 0x06B82


