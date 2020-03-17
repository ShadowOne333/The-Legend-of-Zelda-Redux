//***********************************************************
//	Rearrange Bosses for Both Quests
//***********************************************************

// Changes bosses to:
// 1st Quest - Level 4: Changes the Manhandla in the level to Red Lanmolas, keeps the two-headed Gleeok at the end
// 1st Quest - Level 7: Changes the Aquamentus for a Patra with Oval attack cycle
// 2nd Quest - Level 2: Changes the two-headed Gleeok to Blue Lanmolas (You can still fight a two-headed Gleeok in Level 6)
// 2nd Quest - Level 8: Changes the 3 Dodongos to a Patra with Circle attack cycle

// Dungeons 1-9 1st Quest
bank 3;
org $8006	// $0C016
// Graphics pointer for Dungeon ?
	dw $9A9B	// dungeon?_graphics	// $9A9B (9B 9A)
org $8022	// $0C032
// Graphics pointer for Dungeon ?
	dw $A7DB	// dungeon?_graphics	// $9A9B (DB A7)

// Tables for Dungeons 1-9 1st Quest
bank 6;
org $8810	// $18820
	db $03
org $8813	// $18823
	db $3A
org $8821	// $18831
	db $53
org $8870	// $18880
	db $93
org $8890	// $188A0
	db $86
org $8893	// $188A3
	db $05
org $8B0C	// $18B1C
	dw $E785
org $8B1C	// $18B2C
	db $AA
org $8B2A	// $18B3A
	db $07
org $8B39	// $18B49
	db $EA
org $8B58	// $18B68
	db $85
org $8B6A	// $18B7A
	dl $C586E8
org $8B8D	// $18B9D
	db $48
org $8BAA	// $18BBA
	db $84
org $8E1A	// $18E2A
	db $64
org $8E2B	// $18E3B
	db $7B
org $8E39	// $18E49
	db $52
org $8E3B	// $18E4B
	db $64
org $8E4A	// $18E5A
	dw $643B
org $8E5A	// $18E6A
	db $64
org $8E69	// $18E79
	db $52
org $8E7B	// $18E8B
	db $52
org $8EAB	// $18EBB
	db $05

// Tables for Dungeons 1-9 2nd Quest
org $9109	// $19119
	db $85
org $910B	// $1911B
	db $2C
org $910D	// $1911D
	db $AA
org $9128	// $19138
	db $AA
org $913D	// $1914D
	db $08
org $913F	// $1914F
	db $85
org $916D	// $1917D
	db $07
org $91BD	// $191CD
	db $A4
org $91ED	// $191FD
	db $84
org $924D	// $1925D
	db $03

