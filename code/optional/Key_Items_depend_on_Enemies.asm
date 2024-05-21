// All Key Items depend on All On-Screen Enemies being defeated to appear

//------------------------------------------------------------------

// There are rooms that have an item in plain sight and the enemies in the room don't need to be defeated in order to obtain said item. Such as a map, compass, key, or bombs.

// For example, in Level 3, you have one room with Zols and a key in plain sight. Then in the very next room you face more Zols, but in order to get the key in that room, they must all be defeated.

// There are rooms like that here and there, which gives the impression that the rooms with items in plain sight were not intentional (or maybe it was but it's always bugged me either way). The Wallmaster is probably the only enemy type to makes sense to have the item in plain sight near a wall.

bank 6;
//------------------------------------------------------------------
// LEVEL 1 (Q1) CHANGES

org $89D4	// 0x189E4
// Defeat Keese to get the Compass 
	db $07
org $89C3	// 0x189D3
// Defeat Gels to get the Map
	db $07
org $89C5	// 0x189D5
// Defeat Wallmasters to get the Key
	db $17
//------------------------------------------------------------------
// LEVEL 2 (Q1) CHANGES

org $89EF	// 0x189FF
// Defeat Gels to get the Compass
	db $17
org $89DF	// 0x189EF
// Defeat Gels to get the Map
	db $07
org $89BF	// 0x189CF
// Defeat Keese to get Bombs
	db $07
//------------------------------------------------------------------
// LEVEL 3 (Q1) CHANGES

org $89FB	// 0x18A0B
// Defeat Zols to get the Key
	db $07
org $89CA	// 0x189DA
// Defeat Keese to get the Compass
	db $07
org $89C9	// 0x189D9
// Defeat Keese & Zols to get the Key
	db $07
org $89AA	// 0x189BA
// Defeat Keese to get the Key
	db $07
org $89CC	// 0x189DC
// Defeat Zols to get Map
	db $07
//------------------------------------------------------------------
// LEVEL 4 (Q1) CHANGES

org $89E2	// 0x189F2
// Defeat Vires to get Compass
	db $27
org $89D1	// 0x189E1
// Defeat Keese to get Key 1 
	db $17
org $89C0	// 0x189D0
// Defeat Zols to get Key
	db $27
org $89A1	// 0x189B1
// Defeat Zols to get Map
	db $07
org $8981	// 0x18991
// Defeat Keese to get Key 2
	db $27
//------------------------------------------------------------------
// LEVEL 5 (Q1) CHANGES

org $89AA	// 0x189BA
// Defeat Keese to get Key
	db $27
org $89A7	// 0x189B7
// Defeat Gibdos, Pols Voice, Keese to get Key
	db $27
//------------------------------------------------------------------
// LEVEL 6 (Q1) CHANGES

org $89A9	// 0x189B9
// Defeat Wizzrobes to get Key 1
	db $07
org $899A	// 0x189AA
// Defeat Wizzrobes to get Key 2
	db $07
//------------------------------------------------------------------
// LEVEL 7 (Q1) CHANGES

org $8CF8	// 0x18D08
// Defeat Ropes to get Key
	db $07
org $8CDA	// 0x18CEA
// Defeat Stalfos to get Compass
	db $07
org $8C98	// 0x18CA8
// Defeat All to get Map
	db $07
//------------------------------------------------------------------
// LEVEL 8 (Q1) CHANGES

org $8CFF	// 0x18D0F
// Defeat All to get Key
	db $07
org $8CDF	// 0x18CEF
// Defeat Pols Voice to get Compass
	db $07
org $8CCB	// 0x18CDB
// Defeat Darknuts to get Key
	db $07
//------------------------------------------------------------------
// LEVEL 9 (Q1) CHANGES

org $8CA3	// 0x18CB3
// Defeat Gels to get Bombs
	db $17
org $8CE1	// 0x18CF1
// Defeat Patra to get Key
	db $17
org $8CC7	// 0x18CD7
// Defeat Wizzrobes to get Key
	db $17
//------------------------------------------------------------------

