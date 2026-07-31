//
// Source:
// 	The3Dude & Fiskbit
// 
// License:
// 	Code should be used only for educational, documentation and modding purposes.
// 	Please keep derivative work open source.


// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// When any shutters in a room are opening, Link is allowed to phase through locked keyhole doors for about 1 full second.

bank 5; org $9273	// 0x15283
	bne TouchDoorWall	// 0xC0

org $9235	// 0x15245
TouchDoorWall:
