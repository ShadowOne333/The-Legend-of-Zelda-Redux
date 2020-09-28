//***********************************************************
//		THE LEGEND OF ZELDA REDUX
//***********************************************************


//***********************************************************
//	Table file
//***********************************************************

table code/text.tbl,ltr

//***********************************************************
//	Control codes
//***********************************************************

define	HOLD_PAD_1	$FA

// NES Address conversion

// >> = right shift operator
// % = modulus operator
// | = bitwise OR operator

// bank = (0x06BA5 >> 14) = 1
// addr = (0x06BA5 % 0x4000) = (0x2BA5 | 0x8000) = 0xABA5 - 0x10 = 0xAB95



///***********************************************************
//	File Selection screen
//***********************************************************

// PPU transfer, move "NAME" in the Save Screen one tile to the left
bank 6;
org $A148	// $1A158
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
org $AC7C	// 9x16C8C
	db $20,$A2,$08


// Change all of the "-" that use $62 as their Hex to $2F (to free up one tile)
bank 1;
org $87BD	// $047CD - Dash used for shops and secret caves
	ldx.b #$2F	// Originally LDX #$62
org $89E6	// $049F6 - "+" symbol used for the Money-Making games
	ldx.b #$2B	// Originally LDX #$64
org $89F0	// $04A00 - Dash used for the Money-Making games
	ldx.b #$2F	// Originally LDX #$62

bank 2;
org $9DCD	// $09DDD - Elimination Mode Character detection
	db $2F,$2C	// Dash, Dot (Register Your Name input)
org $9DD3	// $09DE3 - Elimination mode character detection
	db $2E		// Question mark (Register Your Name input)
org $A25F	// $0A26F - File Select File dashes
	db $2F
org $AD9D	// $0ADAD - 2nd Quest Ending dash
	db $2F

bank 6;
org $9D0C	// $19D1C - Dash for "LEVEL-X" in Dungeons
	db $2F
org $A119	// $1A129 - First dash for "-SELECT-"
	db $2F
org $A127	// $1A137 - Second dash for "-SELECT-"
	db $2F
org $A1DE	// $1A1EE - Dash character for Register Name
	db $2F
org $A1E0	// $1A1F0 - Dot character for Register Name
	db $2C
org $A1EA	// $1A1FA - Change dot character for question mark in Register Name
	db $2E
org $A2A1 	// $1A2B1 - UNKNOWN - PPU transfer for something like "-100"?
	db $2F
org $A2A9	// $1A2B9 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2B0	// $1A2C0 - UNKNOWN - PPU transfer for something like "-1     -5"?
	db $2F
org $A2EF	// $1A2FF - First dash for "-LIFE-" 
	db $2F
org $A2F4	// $1A304 - Second dash for "-LIFE-'
	db $2F
// Following two changes are included in automap.asm
//org $BF0E	// $1BF1E - First dash for "-LIFE-" 
//	db $2F
//org $BF13	// $1BF23 - Second dash for "-LIFE-"
//	db $2F


// Change palette of Link on File Select screen
bank 6; org $9CEB	// $19CFB
	db $0F,$29,$27,$17	// Black, green, beige, brown
	db $0F,$22,$27,$17	// Black, blue, beige, brown
	db $0F,$16,$27,$17	// Black, red, beige, brown


// Change palette for the Inner Heart in Elimination Mode
bank 2; org $9EB0	// $09EC0
	lda.b #$02	// Originally A9 30 (LDA #$30)


//***********************************************************
//	Increase text printing speed
//***********************************************************

bank 1; 
// Increase text print speed
org $881C	// $482C
	lda.b #$04	// Originally LDA $06

// Skip SFX sound for spaces in text
//org $884C
//	cmp.b #$25	// Originally CMP #$25


//***********************************************************
//	Implement CAUTION text from version PRG1
//***********************************************************

bank 5;
// Changes Y position of the "Continue/Save/Retry text
org $8AE5	// $14AF5
	db $50,$27,$37,$47	// Originally 4F 67 7F 
// Changes Y position of the red/white flashing when selecting an option to fit the new spacing
org $8AEC	// 0x14AFC
	db $23,$D2,$43
	db $00,$FF,$CB,$CB,$D3


// New text imported into free space from the PRG1 version
bank 6;
// Pointer change
org $A004	// $1A014
	dw save_text	// Pointer originally B4 A2 ($A2B4), changed to D0 AC ($ACD0)
// Fill with FFs (original location of the Continue/Save/Retry text)
org $A2B4	// $1A2C4-$1A2E2
	fill $1F,$FF

// New location:
org $ACD0	// $1ACE0

save_text:
	db $23,$C0,$7F,$00	// PPU Transfer
	db $20,$AC,$08		// PPU Transfer (20 6C 08)
	db "CONTINUE"		// 0C 18 17 1D 12 17 1E 0E - CONTINUE
	db $20,$EC,$04		// PPU Transfer (20 CC 04)
	db "SAVE"		// 1C 0A 1F 0E - SAVE
	db $21,$2C,$05		// PPU Transfer
	db "RETRY"		// 1B 0E 1D 1B 22 - RETRY 
	db $23,$D8,$20		// Text Box Tile attribute PPU transfer - Originally 23 D8 60 55
	db $FF,$5F,$5F,$5F,$5F,$5F,$5F,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $21,$83,$01,$69	// PPU Transfers
	db $21,$84,$58,$6A	// for the box
	db $21,$9C,$01,$6B	// or line tiles
	db $21,$A3,$CB,$6C	// that surround
	db $21,$BC,$CB,$6C	// the Caution
	db $23,$03,$01,$6E	// text
	db $23,$04,$58,$6A	// ...
	db $23,$1C,$01,$6D	// ...
	db $21,$CC,$08		// PPU Transfer
	db "CAUTION!"		// 0C 0A 1E 1D 12 18 17 - CAUTION
	db $22,$05,$16		// PPU Transfer
	db "TO AVOID DAMAGING GAME"	// 1D 18 24 0A 1F 18 12 0D 24 0D 0A 16 0A 10 12 17 10 24 10 0A 16 0E - TO AVOID DAMAGING GAME
	db $22,$45,$16		// PPU Transfer
	db "SAVE DATA, HOLD IN THE"	// 12 17 0F 18 24 24 1C 0A 1F 0E 0D 28 24 24 11 18 15 0D 24 24 12 17 - INFO  SAVED,  HOLD  IN
	db $22,$85,$16		// PPU Transfer
	db "RESET BUTTON WHILE YOU"	// 1B 0E 1C 0E 1D 24 24 0B 1E 1D 1D 18 17 24 24 0A 1C 24 24 22 18 1E - RESET  BUTTON  AS  YOU
	db $22,$C5,$16		// PPU Transfer
	db "TURN OFF THE POWER.   "	// 1D 1E 1B 17 24 19 18 20 0E 1B 24 18 0F 0F 63 - TURN POWER OFF.


// Fix Game Over flashing text (by stratoform)
bank 5;
org $8B55	// 0x14B65
	jsr gameover_flash_call
	nop
	sta.w $0305
	rts

org $BF40	// 0x17F50
gameover_flash_call:
	beq gameover_flash_done	// Old detour code

	lda.b $13		// Get save option (0-2)
	and.b #$03

	tay			// Load correct palette
	lda.w gameover_flash_attr,y

gameover_flash_done:
	rts

gameover_flash_attr:
	db $05,$50,$55


//***********************************************************
//	Save with controller 1 (Up+A)
//***********************************************************

bank 5;
org $80DA	// $140EA
	lda.b {HOLD_PAD_1}	// Originally A5 FB (LDA $FB)


//***********************************************************
//	HUD & Subscreen Changes
//***********************************************************

// Change the "X" in the HUD with a custom tile for a new "x"
bank 1;
org $8795	// $047A5
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for "x" with Rupee icon in secret caves
org $A59D	// $065AD
	lda.b #$62	// Originally A9 21 (LDA #$21) - Used for the Key counter with Infinite symbol
org $A5DB	// $065EB
	ldy.b #$62	// Originally A0 21 (LDY #$21) - Used for main HUD


// Dummy PPU transfer (not applied in-game, can be left without changing)
org $A51D	// $652D - $16C96
	db $20,$6C,$03,$59,$00,$24	// Originally 20 6C 03 21 00 24
	db $20,$AC,$03,$59,$00,$24	// Originally 20 AC 03 21 00 24
	db $20,$CC,$03,$59,$00,$24	// Originally 20 CC 03 21 00 24


// White outline to hearts in HUD (Also changes the outer line of the CAUTION message):
// 0x19XXX: All the dungeon related data in 0x19XXX with the same palette was modified
bank 6;
org $9307	// $19317
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9403	// $19413
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $94FF	// $1950F
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 2)
org $95FB	// $1960B
	db $0F,$16,$28,$30	// Originally 0F 16 27 36 - Changed background color to not collide with Link's (Dungeon 3)
org $9607	// $19617
	db $0F,$29,$27,$17	// Originally 0F 29 37 17 - Change Link's color for Dungeon 3 to not be pale
org $96F7	// $19707
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $97F3	// $19803
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $98EF	// $198FF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $99EB	// $199FB
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9AE7	// $19AF7
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9BE3	// $19BF3
	db $0F,$16,$27,$30	// Originally 0F 16 27 36
org $9CDF	// $19CEF
	db $0F,$16,$27,$30	// Originally 0F 16 27 36


// Subscreen - "USE B BUTTON" text for "B BUTTON" and blank-out below row
org $A039	// $1A049
	db $A3,$50	// Change pointer to upper B button text, label "b_button"
	db $A3,$5C	// Change pointer to lower B button text, label "blank"
org $A350	// $1A360
b_button:
	db $2A,$45,$08
	db "B BUTTON"	// Originally "USE B BUTTON"
	db $FF
org $A35C	// $1A36C
blank:
	db $2A,$64,$08
	db "        "	// Originally "FOR THIS"
blank_rest:
	db $2A,$6F,$01
	db $6E		// Box bottom-left corner
	db $2A,$70,$4B
	db $6A,$2A,$7B,$01,$6D,$FF	// Other tiles for the box
	fill $04,$FF


//***********************************************************
//	Remove extra staircases
//***********************************************************

// Removes the extra staircases outside Level 5 and 6 (1st Quest) and outside a 30 rupees location (2nd Quest)
// The limitation of only one entrance per screen forces them to be just secondary entrances to the labyrinths no matter what, and if you exit the labyrinth when you have entered it from the secondary entrance, the walking on stairs animation is absent.
bank 4; org $8CBA	// $10CCA
	db $70,$B0,$70	// Originally B0 B0 30


//***********************************************************
//	Cracked Walls Tilemaps 
//***********************************************************

// New tilemaps for bombable walls in Dungeons:

bank 5;
// Dungeon Right Walls:
org $A012	// $16022
	db $DF,$5E,$DF,$DF,$F5,$F5,$5F,$DF,$DF,$DF,$F5,$F5	// Originally DF DF DF DF F5 F5 DF DF DF DF F5 F5
// Dungeon Left Walls:
org $A04E	// $1605E
	db $F5,$F5,$DE,$DE,$DE,$58,$F5,$F5,$DE,$DE,$59,$DE	// Originally F5 F5 DE DE DE DE F5 F5 DE DE DE DE
// Dungeon Bottom Wall:
org $A08A	// $1609A
	db $DD,$DD,$F5,$5B,$DD,$F5,$5D,$DD,$F5,$DD,$DD,$F5	// Originally DD DD F5 DD DD F5 DD DD F5 DD DD F5
// Dungeon Top Wall:
org $A0C7	// $160D7
	db $DC,$DC,$F5,$DC,$5A,$F5,$DC,$5C,$F5,$DC,$DC,$F5	// Originally F5 DC DC F5 DC DC F5 DC DC F5 DC DC



// Overworld Walls (Original):
org $A976	// $16987 (Table for Secret Tiles Codes (6 bytes at $16986)
	db $C8, $D8, $C4, $BC, $C0, $C0		// Originally $D8 - Bombable Wall	(D8 D9 DA DB)
// C8	Pushable Rock	(C8 C9 CA CB)
// D8	Bombable Wall	(D8 D9 DA DB)
// C4	Burnable Tree	(C4 C5 C6 C7)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)


// Fix cracked tiles always appearing regardless of Quest No. (by Trax)
org $AAD0	// $16AE0
	jsr $AC40	// Originally LDA $A976,X
org $AC30	// $16C40
	db $C8, $54, $58, $BC, $C0, $C0	// Alternate secret tile codes table
// C8	Pushable Rock	(C8 C9 CA CB)
// 54	Bombable Wall	(54 55 56 57)
// C4	Burnable Tree	(C4 C5 C6 C7)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)
org $AC40	// $16C50 - Free space
	ldy.b $EB	// Current Location
	lda.w $6AFE,y	// Screen Attributes - Table 5 (VRAM)
	bmi quest2	// Bit 7 - 2nd Quest ONLY
	asl
	bmi quest1	// Bit 6 - 1st Quest ONLY
	bpl altTile
quest1:
	ldy.b $16	// Selected Save Slot (0-2)
	lda $062D,y	// 2nd Quest Flag (0 = 1st Quest, 1 = 2nd Quest)
	beq altTile
	bne normalTile
quest2:
	ldy.b $16	// Selected Save Slot (0-2)
	lda.w $062D,y	// 2nd Quest Flag
	bne altTile
normalTile:
	lda.w $A976,x
	rts
altTile:
	lda $AC30,x	// Alternate secret tile codes table
	rts


//Fix overworld cracked walls collision (by stratoform):
bank 7;
org $EEFD	// 0x1EF0D
	lda.b #$04	// Bank 04 (Dungeons)
	jsr $FFAC

	jmp collision_hit_tiles_call


org $F116	// 0x1F126
	lda.b #$04	// Bank 04 (Dungeons)
	jsr $FFAC

	jmp collision_tiles_call


bank 4;
org $BF00	// 0x13F10
collision_tiles_call:
	jsr collision_tiles_sub
	bcs collision_tiles_exit2

	jmp $F14E	// Non-obstacle

collision_tiles_exit2:
	jmp $F11E	// Obstacle

collision_hit_tiles_call:
	jsr collision_tiles_sub
	bcs collision_hit_tiles_exit2

	jmp $EF05	// Non-obstacle

collision_hit_tiles_exit2:
	jmp $EEE4	// Obstacle

collision_tiles_sub:
	jsr $EDFA	// Old detour (Load tile #)

	cmp.b #$54	// $00-53 = Old detour code
	bcc collision_tiles_normal

	// cmp.b #$58 before the new burnable tree sprite.
	// Changed to cmp.b #$60 so the dry tree sprite becomes solid.
	cmp.b #$60	// $54-57 = Secret tiles, solid
	bcc collision_tiles_solid

	// Add more secret tile checks if needed

collision_tiles_normal:
	cmp.w $034A	// Old detour (Range check)
	rts

collision_tiles_solid:
	sec		// Solid obstacle
	rts

// NOTE:
// If something other than Bank 04 needs to be restored,
// check 8000-8003 and swap banks accordingly


//----	Possible burnable tree tile?
// $17930 is free space for this, up to 17C10

// RAM $10 detects overworld or dungeon.
// 00 = Overworld, 01 = Dungeon
// PPU for the specific tiles that could be repurposed for Overworld/Dungeon use depending on area

// PPU addresses correspond to the tiles we want to change: $15A0, $15B0, $15C0, $15D0 (Up/Down Dungeon cracked walls)
// Replacing these 4 tiles depending on whether we are on Overworld or Dungeon, could help create a custom tile for the burnable trees.


bank 3;	//PRG $C000, 0x0C010
org $8051	// Hijack, originally JSR $8091
	jsr TileTransfer
org $8064	// Hijack, originally JSR $8080
	jsr TileTransfer

//Free Space
org $ABE0 // 0x0EBF0
TileTransfer:
	lda.b #$15    	// Set DestPPU $15 upper byte
	sta.w $2006   
	lda.b #$40	// Set DestPPU $40 lower byte base
	sta.w $2006

	ldy.b #$C0	// Dungeon/Overworld assets size
	ldx.b #$00

MapCheck:
	lda.b $10		// Check if in Overworld = 00, or Dungeon = 01
	bne DungeonGFXLoad	// Load Dungeon Walls if in dungeon, else load dry tree

OverworldGFXLoad:
	lda.w OverworldAssets,x
	sta.w $2007
	inx
	dey		// Image size to transfer
	bne OverworldGFXLoad
    
	jsr $8091	// Fix Hijack
	rts

DungeonGFXLoad:
	lda.w DungeonAssets,x
	sta.w $2007
	inx		// Image offset
	dey		// Image size to transfer
	bne DungeonGFXLoad

	jsr $8080	// Fix Hijack
	rts

org $AC10	// 0x0EC20
// Include the Burn Tree and Cracked Walls for Overworld data
OverworldAssets:
	incbin code/gfx/OverworldAssets.bin
// Include the Cracked Up/Down Walls for Dungeons
DungeonAssets:
	incbin code/gfx/DungeonAssets.bin


//***********************************************************
//	Modify Ganon's palette to match artwork
//***********************************************************

bank 6;
org $A205
	db $0F,$06,$22,$30	// Originally 0F 16 2C 3C


//***********************************************************
//	Modify the Sword beam to stop firing at 3/4 hearts
//***********************************************************

bank 7;
// Default value of fire is at full hearts with damage above $80
// Change it to full hearts above $C0 for 1/4 hearts
// The Sword beam stops firing when it reaches 3/4 of the heart's gauge
org $F879	// $1F889
	cmp.b #$C0	// Originally CMP #$80


//***********************************************************
//	Remove 1 Rupee flashing (and possibly make it green too?)
//***********************************************************

// The color switch is 8 frames, and applies to a few objects, like small hearts, Triforce pieces, etc. I looked for all occurences of RAM $15, which is a frame counter. So, starting at 1E735, there's code that determines which items should be flashing. So replace this code with NOPs (EA):

bank 7;
org $E73D	// $1E74D
	nop	// Originally CPX #$16
	nop	// Originally CPX #$16
	nop	// Originally BEQ $0C -> 1E74D
	nop	// Originally BEQ $0C -> 1E74D

// At 6B5C, there's a table with palette codes for various things. 
// Change value at 6B72 to make the rupee another color if you want.
// 00 - Link, 01 - Orange, 02 - Blue, 03 - Zora/Moblin


//***********************************************************
// Reworked Save Selection screen, similar to Zelda 2 Redux
//***********************************************************

// (PENDING, LEAVING FOR LAST)
//bank 2; org $A5A2	// $0A5B2 - File Select screen code
//	and.b #$04		// Originally 29 20 - Changes the button input which moves the cursor in File Select screen
//bank 5; org $8B01	// $14B11
//	and.b #$04		// Originally 29 20 - Changes the button input which moves the cursor in the Continue/Save/Retry screen



//***********************************************************
//	Kill Pols Voice by using the flute and/or arrows
//***********************************************************

// Code by Stratoform from RomHacking.net

bank 4;
org $9C36	// 0x11C46
	jsr flute_pols_call

org $BF30	// 0x13F40
flute_pols_call:
	jsr $79D0	// Detour code

	lda.w $051B	// Flute (0) = Unused, exit
	beq flute_pols_exit

	lda.b $28,x	// Timer (0) = Start SFX
	bne flute_pols_timer

	lda.b #$44+$80-1   // Timer = x44 frames
	sta.b $28,x
	rts

flute_pols_timer:
	bmi flute_pols_exit	// Timer (x80+) = Playing SFX
	// Timer (x7F) = done
	jsr $FEA6	// Kill all pols

flute_pols_exit:
	rts


//***********************************************************
// Select button toggles between selected B button items
//***********************************************************

// Max value is $08. After 08 it jumps to the Raft and other Key items.
// Routine begins at $EC1B (0x1EC2B), ends at $EC79 (0x1EC89)
// Pause check begins at 1EC46, compares if Select has been pressed and then does LDA $00E0, EOR #$01 and STA $00E0 to #$01 (RAM $00E0), which tells the game it is Paused. Bypassing the Pause can be done by NOP'ing the LDA/EOR/STA starting at 0x1EC4C ($EC3C).

bank 7; org $EC3C  // $1EC4C
	// Switch to bank 5
	lda.b #$05
	jsr $FFAC
	// Hijack PAD_SELECT pressed on the overworld
	jsr quick_select

bank 5; org $BFC0  //$17FD0
quick_select:
	lda.b #$01	// PAD_RIGHT
	ldy.w $0656	// Load current item
	jsr $B7A8	// Get next item $B7C8 (use 'jsr $B7A8' to also play SFX)
// Old Letter overflow fix by gzip
	ldy.w $0656	// Load current item position
	cpy.b #$10	// Compare if value is $10 (out of range)
	bpl out_range	// BPL $03 - Go to out_range if its out of range
	jmp return	// End routine
out_range:
	ldy.w $065F	// Load Magical Rod address
	cpy.b #$01	// Check if Magic Rod is obtained
	bne no_rod	// BNE $08 - Jump to no_rod if there's no Rod
	lda.b #$08	// If Magic Rod is obtained, load its position
	sta.w $0656	// Store Rod position in current item position
	jmp return	// End routine
no_rod:
	lda.b #$00	// Load value $00 into stack
	sta.w $0656	// Store $00 in the current item position
return:
	rts


//***********************************************************
// Save Hearts number if last session had 3+ hearts of health
//***********************************************************

// (PENDING)



//***********************************************************
// Aquamentus color change from Green to Red
//***********************************************************

//bank 6;
//org $A291	// $1A29E
//	db $0F,$13,$16,$35
