//
// Source:
// 	minucce
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

bank 5; org $1454E	// 0x1455E

// Reset Y-scroll value with more precision
	ldy.b #$5E+2

-;	nop		// Manual timing
	dey
	bpl -

	nop
	nop
	nop
	nop
	nop
	nop

	lda.w $2002	// Reset latch

	lda.b $58	// Render-Y2
	ldy.b $E2	// Render-Y1

	// Credit to Quietust (nesdev) for explaining PPU Addr register scrolling

	sta.w $2006
	lda.b #$00

	sty.w $2006	// Render location  (must be h-blank)
	sta.w $2005	// Fine X-pos
	rts
