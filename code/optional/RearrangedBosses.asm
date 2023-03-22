//***********************************************************
//	Rearrange Bosses for Both Quests
//***********************************************************

// Changes bosses to:
// 1st Quest - Level 3/4: Changes the Manhandla in the level to Red Lanmolas, keeps the two-headed Gleeok at the end
// 1st Quest - Level 7: Changes the Aquamentus for a Patra with Oval attack cycle
// 2nd Quest - Level 2: Changes the two-headed Gleeok to Blue Lanmolas (You can still fight a two-headed Gleeok in Level 6)
// 2nd Quest - Level 8: Changes the 3 Dodongos to a Patra with Circle attack cycle

// Dungeons 1-9 1st Quest
bank 3;
org $8006	// 0x0C016
// Graphics pointer for Dungeon 3 (1st Quest)
	dw $9A9B	// Dungeon 3 GFX, Originally $987B (7B 98)
org $8022	// 0x0C032
// Graphics pointer for Dungeon 8 (2nd Quest)
	dw $A7DB	// Dungeon 8 GFX, Originally $9FDB (DB 9F)

// Tables for Dungeons 1-9 1st Quest
// $03 = Gleeok (2 Heads)
// $06 = Flying Gleeok Head
// $3A = Red Landmola
// $3C = Mandhandla
bank 6;
org $8810	// 0x18820
// Level 4 Mini-Boss. Changed to Gleeok 2-H
	db $03	// Originally $3C (Mandhandla)
org $8813	// 0x18823
// Level 4 Boss. Changed to Red Landmola
	db $3A	// Originally $03 (Gleeok 2-Headed)
org $8821	// 0x18831
	db $53
org $884D	// 0x1885D
// Level 3 Boss. $3A is Red Landmolas, $3C is Manhandla
	db $3C	// Originally $3C
org $8859	// 0x18869
	db $64
org $885B	// 0x1886B
	dw $2464
org $8869	// 0x18879
	db $E4
org $8870	// 0x18880
	db $93
org $8890	// 0x188A0
// Level 4. Add Mixed Types byte
	db $86	// Originally $06
org $8893	// 0x188A3
// Level 4. Removed Mixed Types byte
	db $05	// Originally $85
org $8B0C	// 0x18B1C
	dw $E785
org $8B1C	// 0x18B2C
	db $AA
org $8B2A	// 0x18B3A
	db $07
org $8B39	// 0x18B49
	db $EA
org $8B58	// 0x18B68
	db $85
org $8B6A	// 0x18B7A
	dl $C586E8
org $8B8D	// 0x18B9D
	db $48
org $8BAA	// 0x18BBA
	db $84
org $8E1A	// 0x18E2A
	db $64
org $8E2B	// 0x18E3B
	db $7B
org $8E39	// 0x18E49
	db $52
org $8E3B	// 0x18E4B
	db $64
org $8E4A	// 0x18E5A
	dw $643B
org $8E5A	// 0x18E6A
	db $64
org $8E69	// 0x18E79
	db $52
org $8E7B	// 0x18E8B
	db $52
org $8EAB	// 0x18EBB
	db $05

// Tables for Dungeons 1-9 2nd Quest
org $9109	// 0x19119
	db $85
org $910B	// 0x1911B
	db $2C
org $910D	// 0x1911D
	db $AA
org $9128	// 0x19138
	db $AA
org $913D	// 0x1914D
	db $08
org $913F	// 0x1914F
	db $85
org $916D	// 0x1917D
	db $07
org $91BD	// 0x191CD
	db $A4
org $91ED	// 0x191FD
	db $84
org $924D	// 0x1925D
	db $03
