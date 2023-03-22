//
// Source:
// 	minucce
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

bank 5;
org $AAB4	// 0x16AC4
	jsr hud_loading_blink
	nop

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

org $AF40	// 0x16F50+$2C

//
// Turn on BG display during VBlank; Disable after HUD scanline
//

hud_loading_blink:
	inc.b $06

	lda.b $06
	cmp.b #$10	// Done loading
	beq .exit
	and.b #$03	// Redraw every 4 frames
	bne .exit


	lda.b $12	// Verify overworld transition
	cmp.b #$0A
	beq +
	cmp.b #$0B
	bne .exit
+;
-;	
	lda.w $2002	// Wait pre-render scanline -1
	asl
	bmi -

	lda.b #$1E	// Enable drawing
	sta.w $2001

	jsr $8521	// Draw HUD

.exit:
	lda.b $06
	rts
