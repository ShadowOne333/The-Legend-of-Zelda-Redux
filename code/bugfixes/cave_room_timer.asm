//
// Source:
// 	minucce
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Reset timer for cave start
//

bank 1; org $86A3	// 0x46B3

	sta.b $70,x	// x,y
	sty.b $84,x

	lda.b #$00	// HP
	sta.w $0485,x

	sta.b $29	// Cloud timer

	lda.b #$81	// Attr
	sta.w $04BF,x

	lda.b #$40	// Freeze player
	sta.b $AC

	sta.w $0351	// Bonfire 1,2
	sta.w $0352

	lda.b #$48	// x1
	sta.b $71,x

	lda.b #$A8	// x2
	sta.b $72,x

	sty.b $85,x	// y1, y2
	sty.b $86,x

	rts

