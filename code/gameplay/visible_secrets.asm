//***********************************************************
//	Cracked Walls & Burnable Trees Tilemaps 
//***********************************************************

// New tilemaps for bombable walls in Dungeons:

bank 5;
// Dungeon Right Walls:
org $A012	// 0x16022
	db $DF,$5E,$DF,$DF,$F5,$F5,$5F,$DF,$DF,$DF,$F5,$F5	// Originally DF DF DF DF F5 F5 DF DF DF DF F5 F5
// Dungeon Left Walls:
org $A04E	// 0x1605E
	db $F5,$F5,$DE,$DE,$DE,$58,$F5,$F5,$DE,$DE,$59,$DE	// Originally F5 F5 DE DE DE DE F5 F5 DE DE DE DE
// Dungeon Bottom Wall:
org $A08A	// 0x1609A
	db $DD,$DD,$F5,$5B,$DD,$F5,$5D,$DD,$F5,$DD,$DD,$F5	// Originally DD DD F5 DD DD F5 DD DD F5 DD DD F5
// Dungeon Top Wall:
org $A0C7	// 0x160D7
	db $DC,$DC,$F5,$DC,$5A,$F5,$DC,$5C,$F5,$DC,$DC,$F5	// Originally F5 DC DC F5 DC DC F5 DC DC F5 DC DC



// Original Overworld Walls & Trees:
org $A976	// 0x16987 (Table for Secret Tiles Codes (6 bytes at $16986)
	db $C8,$D8,$C4,$BC,$C0,$C0		// Originally $D8 - Bombable Wall	(D8 D9 DA DB)
// C8	Pushable Rock	(C8 C9 CA CB)
// D8	Bombable Wall	(D8 D9 DA DB)
// C4	Burnable Tree	(C4 C5 C6 C7)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)


// Fix cracked tiles always appearing regardless of Quest No. (by Trax)
org $AAD0	// 0x16AE0
	jsr $AC40	// Originally LDA $A976,X


// New Overworld Cracked Walls and Burnable Trees, Free space
org $AC30	// 0x16C40
	db $C8,$58,$5C,$BC,$C0,$C0	// Alternate secret tile codes table
// C8	Pushable Rock	(C8 C9 CA CB)
// 54	Bombable Wall	(58 59 5A 5B)
// C4	Burnable Tree	(5C 5D 5E 5F)
// BC	Pushable Tomb	(BC BD BE BF)
// C0	Armos Statue	(C0 C1 C2 C3)
// C0	Armos Statue	(C0 C1 C2 C3)
org $AC40	// 0x16C50 - Free space
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
	lda.b #$04	// Change to Bank 04 (Dungeons)
	jsr $FFAC

	jmp collision_hit_tiles_call


org $F116	// 0x1F126
	lda.b #$04	// Change to Bank 04 (Dungeons)
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

	cmp.b #$54	// $00-54 = Old detour code
	bcc collision_tiles_normal

	// cmp.b #$58 before the new burnable tree sprite.
	// Changed to cmp.b #$60 so the dry tree sprite becomes solid.
	cmp.b #$60	// $54-5B = Secret tiles, solid
	bcc collision_tiles_solid

	// Add more secret tile checks if needed

collision_tiles_normal:
	cmp.w $034A	// Old detour (Range check)
	rts

collision_tiles_solid:
	sec		// Solid obstacle
	rts


// Add rock arc at the top of bombable walls, so they don't look as plain black squares
bank 4; org $8F08	// 0x10F18
// Modification so the bombed walls use out custom arc cave tiles ($54,$55,$56,$57) instead of being all black tiles ($24)
	lda.b #$54	// Originally LDA #$24

// Fix recently bombed overworld wall collision and tile properties (Unsure what this does precisely)
// (Routine for the following code begins at $ABC4 (0x16BD4)
bank 5; org $ABED	// 0x16BFD
	cmp.b #$57	// Originally CMP #$27



//***********************************************************
//	Tile Loading
//***********************************************************

// $17930 is free space for this, up to 17C10

// RAM $10 detects overworld or dungeon.
// 00 = Overworld, 01 = Dungeon
// PPU for the specific tiles that could be repurposed for Overworld/Dungeon use depending on area

// PPU addresses correspond to the tiles we want to change: $15A0, $15B0, $15C0, $15D0 (Up/Down Dungeon cracked walls)
// Replacing these 4 tiles depending on whether we are on Overworld or Dungeon, could help create a custom tile for the burnable trees.

bank 3;
org $8051	// 0x0C061
	jsr TileTransfer	// Hijack, originally JSR $8091
org $8064	// 0x0C074
	jsr TileTransfer	// Hijack, originally JSR $8080

//Free Space
org $ABE0	// 0x0EBF0
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


