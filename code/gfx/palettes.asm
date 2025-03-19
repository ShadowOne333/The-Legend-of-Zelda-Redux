//***********************************************************
//	Palette changes
//***********************************************************

//***********************************************************
//	Make Blue tunic more vivid 
//***********************************************************

bank 1; org $AB95	// 0x6BA5
	db $29,$22,$16	// Green, blue, red

bank 2; org $A287	// 0xA297
	db $29,$22,$16	// Green, blue, red

//***********************************************************
//	Modify Ganon's palette to match artwork
//***********************************************************

// If Ganon is left idle during his Arrow-vulnerable state, if he goes back to his moving state, he reverts to the original palette.
// This forces the palette to be the same.
bank 4; org $AF67	// 0x12F77
	db $06,$22,$30		// Originally 16 2C 3C

// Normal palette when first encountering Ganon.
bank 6; org $A205	// 0x1A215
	db $0F,$06,$22,$30	// Originally 0F 16 2C 3C

//***********************************************************
//	Photosensitivity patch to attenuate
//		Triforce Get flash
//***********************************************************
bank 6; org $A272
	db $3F,$08,$08
	db $0F,$2D,$2D,$10	// Originally 0F 30 30 30
	db $0F,$2D,$2D,$10	// Originally 0F 30 30 30	
	db $FF

//***********************************************************
//	Aquamentus color change from Green to Red
//***********************************************************

//bank 6;
//org $A291	// 0x1A29E
//	db $0F,$13,$16,$35

