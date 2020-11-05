//****************************************************************
//	Main menu tweaks (by SpiderDave)
//****************************************************************

bank 2;

// Allow selecting empty save slots from main file menu
org $A5BC
	nop
	nop

// Can press start to end name registration with start button while a file is selected
org $9EF4 
	nop
	nop
	lda.b $F8
	cmp.b #$10

// This normally does INC $13 and RTS, which starts the game.
// Jump to our new subroutine below instead.
org $A5DC
	jmp $BFC0

// This is where it checks for select button to move the cursor in register and elim mode.
// We'll have it do an extra check so it only works in elim mode.
org $A204
    jsr checkForElimMode
    nop

// BFC0: Unused Space (3A bytes) uses 0x21/0x3a bytes
org $BFC0
    ldy.b $16
    lda.w $0633,y
    beq RegisterName
    inc.b $13
    rts
// Changes mode to name registration
RegisterName: 
    lda.b #$0E
    sta.b $12
    lda.b #$00
    sta.b $11
    rts
// Adds an extra check to invalidate pressing select in register mode.
checkForElimMode:
    lda.b $12
    cmp.b #$0F
    bne noElimMode
    lda.b $F8
    and.b #$20
    rts
noElimMode:
    lda.b #$00
    rts

// Return to main menu after elimination mode instead of register
org $9FD4
    lda.b #$01
