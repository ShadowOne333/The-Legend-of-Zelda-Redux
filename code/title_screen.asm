//****************************************
// Title screen changes
//****************************************

//****************************************
// Hyrule Fantasy subtitle tiles
//****************************************

bank 6;
// Tiles
org $AA15	// 0x1AA25
	db $E2,$24,$24,$5D,$54,$56,$58,$5A,$5C,$C2,$C3	// Originally E2 24 24 24 24 24 24 24 C1 C2 C3
	db $C4,$C5,$55,$57,$59,$5B,$5D,$24,$24,$24,$E3	// Originally C4 C5 24 24 24 24 24 24 24 24 E3
// Attribute table
org $AC9F	// 0x1ACAF
	db $6E,$5F,$57,$5D,$DF,$BB	// Originally 6E 5F 55 5D DF BB

bank 2;
// Attribute table
org $9500	// 0x0x9510
	db $12		// Originally 22
org $9510	// 0x0x9520
	db $12		// Originally 22
org $9978	// 0x0x9988
	db $12		// Originally 22
org $9988	// 0x0x9998
	db $12		// Originally 22
org $9998	// 0x0x99A8
	db $12		// Originally 22
org $99A8	// 0x0x99B8
	db $12		// Originally 22
org $99B8	// 0x0x99C8
	db $12		// Originally 22
org $99C8	// 0x0x99D8
	db $12		// Originally 22
org $99D8	// 0x0x99E8
	db $12		// Originally 22
org $99E8	// 0x0x99F8
	db $12		// Originally 22
org $99F8	// 0x0x9A08
	db $12		// Originally 22
org $9A08	// 0x0x9A18
	db $12		// Originally 22
org $9A18	// 0x0x9A28
	db $12		// Originally 22
org $9A28	// 0x0x9A38
	db $12		// Originally 22
org $9A38	// 0x0x9A48
	db $12		// Originally 22
org $9A48	// 0x0x9A58
	db $12		// Originally 22

//****************************************
// Waterfall slow animation
//****************************************

org $98F5	// $09905
	nop
	nop
	nop

//****************************************
// ZELDA tiles palette
//****************************************

org $985E	// $0986E
	db $36,$16,$27,$0F

//****************************************
// Triforce glow
//****************************************

org $9863	// $09873
	db $28,$28,$28,$38,$38,$30,$30,$38

//****************************************
// Title screen fade out
//****************************************

org $996C	// $0997C
	db $10,$36,$16,$27
org $997C	// $0998C
	db $16,$36,$16,$27
org $998C	// $0999C
	db $10,$39,$16,$27
org $999C	// $099AC
	db $16,$39,$16,$27
org $99AC	// $099BC
	db $10,$31,$16,$27
org $99BC	// $099CC
	db $16,$31,$16,$27
org $99CC	// $099DC
	db $10,$3C,$16,$27
org $99DC	// $099EC
	db $16,$3C,$16,$27
org $99EC	// $099FC
	db $10,$3B,$16,$27
org $99FC	// $09A0C
	db $16,$3B,$16,$27
org $9A0C	// $09A1C
	db $10,$2C,$16,$27
org $9A1C	// $09A2C
	db $16,$2C,$16,$27
org $9A2C	// $09A3C
	db $10,$1C,$16,$27
org $9A3C	// $09A4C
	db $16,$1C,$16,$27
