//****************************************************************
//	Main menu tweaks (by SpiderDave)
//****************************************************************

bank 2;
// Allow selecting empty save slots from main file menu
org $A5BC	// 0x0A5CC
	nop
	nop

// Can press start to end name registration with start button while a file is selected
org $9EF4 	// 0x09F04
	nop
	nop
	lda.b $F8	// Load inputs from Controller 1
	cmp.b #$10	// Check if Select has been pressed

// This normally does INC $13 and RTS, which starts the game.
// Jump to our new subroutine below instead.
org $A5DC	// 0x0A4EC
	jmp $BFC0

// This is where it checks for select button to move the cursor in register and elim mode.
// We'll have it do an extra check so it only works in elim mode.
org $A204	// 0x0A214
    jsr checkForElimMode
    nop

// BFC0: Unused Space (3A bytes) uses 0x21/0x3a bytes
org $BFC0	// 0x0BFD0
    ldy.b $16		// Load $16, Select save slot
    lda.w $0633,y	// Load RAM for Save Slot 1
    beq RegisterName	// Branch if Save Slot 1 exists
    inc.b $13
    rts
// Changes mode to name registration
RegisterName:	// 0x0BFDA
    lda.b #$0E		// Load "Register Name" ($0E) into accumulator
    sta.b $12		// Store at Game Mode address
    lda.b #$00		// Load $00 into accumulator
    sta.b $11
    rts
// Adds an extra check to invalidate pressing select in register mode.
checkForElimMode:	// 0x0BFE3
    lda.b $12		// Load Game Mode address
    cmp.b #$0F		// Compare if it's Elimination Mode ($0F)
    bne noElimMode	// If not, branch to Not-Elimination
    lda.b $F8		// Load inputs from Controller 1
    and.b #$20		// Check if Start has been pressed
    rts
noElimMode:	// 0x0BFED
    lda.b #$00		// Load $00 into accumulator
    rts

// Return to main menu after elimination mode instead of register
org $9FD4	// 0x09FE4
    lda.b #$01


