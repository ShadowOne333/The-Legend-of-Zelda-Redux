//
// 	Like Likes Consume Rupees
//	(gzip's Zelda Hack Pack)

//------------------------------------
// Modify the address so instead of changing the shield address it will now modify the "rupees to substract" RAM address

bank 4; org $9D34	// 0x11D44
	lda.b #$01	// Originally LDA #$00
	sta.w $067E	// Originally STA $0676
