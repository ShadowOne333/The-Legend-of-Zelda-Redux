//
// 	Low Hearts Heartbeat Sound
//	(gzip's Zelda Hack Pack)

//------------------------------------
// Modify the low heart beeping sound to be more soft, like a heartbeat kind-of sound

bank 0; org $9862	// 0x1872
// Original sound bytes - 95 50 08 08 08 08 08 90
	db $9C,$80,$80,$08,$08,$08,$08,$08
