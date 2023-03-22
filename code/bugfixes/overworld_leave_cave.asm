//
// Source:
// 	minucce
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


//
// Reset sprite position on entering overworld from caves
//


bank 5; org $14F5D	// 0x14F6D
	jsr hide_sprite
	nop

// #####################################################

org $14F61	// 0x14F71
	stx.b $00
	jsr $F184	// Reset vars
	ldx.b $00

	rts

org $8F69; hide_sprite:	// $14F69, 0x14F79
	lda.b #$0A	// Transition out of cave
	sta.b $12

	lda.b #$F8	// Hide sprite
	sta.b $84

	nop
	rts		// org $14F72, 0x14F82
