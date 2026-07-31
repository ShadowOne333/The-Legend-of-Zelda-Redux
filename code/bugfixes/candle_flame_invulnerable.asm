//
// Source:
// 	The3Dude
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

//
// Makes Link be unable to burn himself with his own fire from the Candles or Rod.
// This helps prevent damage boosting over Stepladder holes in certain ROM hacks.
// If you leave this flame hitbox on, instead of off, Link is able to touch his own candle fire. And the candle fire can damage boost you horizontally when going vertically on a stepladder and vice versa, effectively breaking the rules of the ladder.
// Use this if you want to prevent exploits.
// The fire will still hurt enemies, just not Link.

bank 7; org $F8F2	// 0x1F902
	lda.b #$00	// Previously LDA #$0E

