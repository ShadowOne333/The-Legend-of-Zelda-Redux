//------------------------------------
// Restore the Dungeon 1 Door Glitch
//------------------------------------

// Reset dungeon room door flags

bank 5; org $B4A5	// 0x174B5
	sta.w $0526

