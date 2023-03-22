//***********************************************************
//	Overworld screens column changes
//***********************************************************

// Initial column changes coutesy of gzip
// Change some overworld screens to not be as "blocky" by modyfying the default column definitions some screens have

// Column definitions begin at $15418 (0x15428) with screen A-1 and end at P-8 ($15BD7, 0x15BE7), going from top-left to bottom-right, left-to-right in order

//------------------------------------
//   Screens and Columns pointers
//------------------------------------

// Main pointers
bank 5; org $9F9C	// 0x15FAC
	dw overworld_column_data	// Originally $9418


//------------------------------------
//	Screen column definitions
//------------------------------------
// Divided by Screen-rows, left-to-right

bank 5; org $9418	// 0x15428
overworld_column_data:
// Screen A-1
	db $00,$00,$00,$00,$00,$00,$00,$50
	db $01,$01,$81,$01,$01,$01,$01,$01

// Screen B-1 column definitions, $15428 / 0x15438
// Modified 1st and 3rd column
	db $01,$F1,$C8,$A0,$A1,$A0,$06,$38
	db $A1,$D2,$A5,$A4,$A2,$A3,$F0,$A6

// Screen C-1 column definitions, $15438 / 0x15448
	db $01,$01,$01,$50,$01,$01,$81,$01
	db $01,$A7,$A9,$C8,$C7,$A0,$06,$06

// Screen D-1 column definitions, $15448 / 0x15458
	db $A1,$A5,$A4,$A8,$F0,$A6,$01,$81
	db $01,$01,$50,$00,$00,$00,$00,$00

// Screen E-1 column definitions, $15458 / 0x15468
	db $00,$E6,$06,$06,$A1,$A0,$E7,$E6
	db $A1,$84,$90,$02,$10,$02,$02,$A8

// Screen F-1 column definitions, $15468 / 0x15478
	db $A9,$A8,$A9,$03,$05,$E4,$24,$02
	db $02,$03,$05,$22,$24,$02,$A8,$A6

// Screens G-1 & I-1 column definitions, $15478 / 0x15488
	db $A7,$A6,$A7,$F1,$A9,$A8,$A9,$A2
	db $A3,$A8,$A6,$A7,$A6,$A7,$A6,$01

// Screen H-1 column definitions, $15488 / 0x15498
	db $01,$01,$01,$01,$50,$01,$A7,$F1
	db $F0,$A6,$81,$01,$A7,$A6,$01,$01

// Screen I-1 shared with G-1, $15478 / 0x15488

// Screen J-1 column definitions, $15498 / 0x154A8
	db $A7,$A9,$A8,$A9,$71,$32,$33,$02
	db $34,$02,$34,$02,$34,$A8,$F0,$00

// Screen K-1 column definitions, $154A8 / 0x154B8
	db $00,$A9,$10,$53,$54,$B1,$55,$B2
	db $54,$54,$54,$56,$02,$B5,$A8,$00

// Screen L-1 column definitions, $154B8 / 0x154C8
	db $00,$F1,$A9,$B7,$02,$B7,$67,$68
	db $70,$B7,$02,$B7,$A5,$A4,$A8,$00

// Screen M-1 column definitions, $154C8 / 0x154D8
	db $00,$00,$00,$00,$00,$50,$A7,$A9
	db $10,$02,$A2,$A3,$F0,$F1,$A9,$02

// Screen N-1 column definitions, $154D8 / 0x154E8
	db $02,$02,$A8,$F0,$F1,$A9,$A5,$A4
	db $02,$D2,$C8,$C7,$A0,$38,$E7,$00

// Screen O-1 column definitions, $154E8 / 0x154F8
// Modified 1st to 10th columns
	db $80,$80,$80,$80,$80,$96,$80,$80
	db $80,$80,$13,$13,$13,$13,$13,$13

// Screen P-1 column definitions, $154F8 / 0x15508
// Modified 3rd and 14th columns
	db $13,$00,$02,$02,$67,$70,$02,$67	// $13,$00
	db $D7,$70,$02,$67,$70,$02,$00,$13	// $00,$13

//------------------------------------

// Screen A-2 column definitions, $15508 / 0x15518
	db $00,$F1,$A9,$02,$33,$02,$32,$B6
	db $34,$D2,$02,$64,$F2,$F3,$02,$64

// Screen B-2 column definitions, $15518 / 0x15528
	db $66,$02,$E5,$D8,$66,$02,$02,$B6
	db $71,$02,$32,$02,$33,$02,$A8,$00

// Screen C-2 column definitions, $15528 / 0x15538
	db $00,$E6,$06,$83,$06,$A1,$84,$90
	db $D2,$64,$F2,$F3,$64,$F2,$F3,$64

// Screen D-2 column definitions, $15538 / 0x15548
	db $66,$02,$D2,$C8,$C7,$A0,$06,$06
	db $06,$06,$83,$06,$A1,$84,$90,$02

// Screen E-2 column definitions, $15548 / 0x15558
	db $02,$A2,$A3,$B7,$02,$02,$B7,$02
	db $02,$B7,$B5,$02,$D2,$B7,$C8,$A0

// Screen F-2 column definitions, $15558 / 0x15568
	db $06,$E7,$E6,$38,$06,$E7,$E6,$A1
	db $A2,$A3,$A8,$A9,$D2,$B5,$A8,$A9

// Screen G-2 column definitions, $15568 / 0x15578
// Modified 8th & 11th column
	db $A8,$A9,$A2,$A3,$A8,$A9,$D2,$02	// $02
	db $A0,$06,$A1,$A6,$A7,$F1,$A9,$02

// Screen H-2 column definitions, $15578 / 0x15588
// Modified 6th, 8th & 12th column
	db $A5,$A4,$C8,$A0,$83,$06,$B4,$B0	// $02,$B0
	db $B0,$B0,$B0,$73,$73,$73,$73,$73	// $73

// Screen I-2 column definitions, $15588 / 0x15598
// Modified 9th column
	db $73,$73,$73,$73,$73,$73,$73,$73
	db $72,$72,$72,$72,$D4,$72,$72,$72	// $73

// Screen J-2 column definitions, $15598 / 0x155A8
	db $72,$72,$72,$72,$D4,$72,$72,$72
	db $72,$72,$72,$72,$72,$72,$72,$72

// Screen K-2 column definitions, $155A8 / 0x155B8
// Modified 8th, 15th & 16th columns
	db $72,$72,$72,$72,$72,$72,$C1,$06
	db $06,$06,$06,$06,$06,$83,$06,$01

// Screen L-2 column definitions, $155B8 / 0x155C8
// Possible change in the 7th and last column!
	db $01,$A7,$A9,$32,$02,$33,$02,$11
	db $32,$02,$32,$02,$71,$A8,$A6,$01

// Screen M-2 column definitions, $155C8 / 0x155D8
	db $A7,$A9,$02,$B5,$02,$B6,$02,$B7
	db $02,$B7,$02,$B7,$02,$B7,$02,$02

// Screen N-2 column definitions, $155D8 / 0x155E8
// Modified 10th column
	db $02,$02,$B5,$71,$A8,$00,$E6,$04
	db $04,$D6,$97,$91,$51,$B8,$51,$51

// Screen O-2 column definitions, $155E8 / 0x155F8
// Modified 8th, 9th & 10th columns
	db $51,$51,$51,$51,$51,$B8,$51,$01	// 
	db $01,$90,$02,$02,$D2,$02,$02,$02

// Screen P-2 column definitions, $155F8 / 0x15608
// Modified 14th column
	db $02,$02,$64,$66,$E5,$D8,$65,$66
	db $E5,$F3,$64,$F2,$F3,$02,$00,$13	// 

//------------------------------------

// Screen A-3 column definitions, $15608 / 0x15618
// Modified 3rd and 15th column
	db $00,$00,$E2,$82,$07,$07,$88,$07
	db $07,$82,$07,$07,$82,$07,$02,$02

// Screen B-3 column definitions, $15618 / 0x15628
// Modified 2nd, 14th, 15th & 16th columns
	db $02,$02,$07,$82,$07,$07,$82,$07	// $02
	db $07,$88,$07,$07,$82,$07,$15,$15	// $07,$15,$15

// Screen C-3 column definitions, $15628 / 0x15638
// Modified 3rd and 14th columns (Dungeon 6 Entrance)
// Pending Palette modifications!
	db $00,$00,$02,$B7,$B7,$B7,$67,$D7
	db $F5,$70,$B7,$B7,$B7,$02,$00,$00

// Screen D-3 column definitions, $15638 / 0x15648
	db $00,$A9,$02,$71,$32,$34,$B5,$A8
	db $00,$00,$A9,$02,$02,$B5,$02,$02

// Screen E-3 column definitions, $15648 / 0x15658
	db $02,$02,$B7,$A8,$A9,$B7,$A2,$A3
	db $B7,$02,$B6,$B7,$A2,$A3,$B7,$02

// Screen F-3 column definitions, $15658 / 0x15668
	db $02,$02,$B7,$B6,$B5,$B7,$A2,$A3
	db $B7,$02,$10,$B7,$02,$B6,$A8,$00

// Screen G-3 column definitions, $15668 / 0x15678
// Modified 5th & 10th column
	db $00,$A9,$07,$D3,$02,$A8,$F0,$F1	// $02
	db $A9,$39,$91,$51,$97,$91,$51,$97	// $39

// Screen H-3 column definitions, $15678 / 0x15688
// Modified 6th column
	db $91,$51,$97,$91,$51,$97,$13,$C3	// $97
	db $58,$58,$58,$91,$51,$97,$85,$47

// Screen I-3 column definitions, $15688 / 0x15698
	db $61,$61,$61,$61,$61,$61,$60,$76
	db $76,$17,$17,$26,$17,$31,$28,$17

// Screen J-3 column definitions, $15698 / 0x156A8
	db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9
	db $F9,$F9,$F9,$F9,$F9,$F9,$F9,$F9

// Screen K-3 column definitions, $156A8 / 0x156B8
// Modified 2nd & 16th columns
	db $F9,$F9,$C4,$C4,$C4,$C4,$C4,$C4	// $F9
	db $C4,$C4,$C4,$C4,$C4,$C4,$C4,$F9	// $F9

// Screen L-3 column definitions, $156B8 / 0x156C8
// Modified 2nd & 15th columns
	db $F9,$C4,$C4,$C4,$C4,$C4,$C4,$C4	// $F9
	db $C4,$C4,$C4,$C4,$C4,$C4,$F9,$F9	// $F9

// Screen M-3 column definitions, $156C8 / 0x156D8
// Modified 12th column
	db $02,$02,$02,$B6,$02,$03,$05,$21
	db $21,$E4,$24,$02,$A0,$06,$06,$06	// $02

// Screen N-3 column definitions, $156D8 / 0x156E8
// Modified 5th & 10th column
	db $06,$06,$83,$A1,$02,$D2,$A2,$18	// $02
	db $18,$35,$36,$36,$36,$36,$36,$36	// $35

// Screen O-3 column definitions, $156E8 / 0x156F8
// Modified 2nd column
	db $36,$36,$52,$52,$52,$52,$52,$52	// $36
	db $86,$E1,$13,$13,$13,$13,$13,$13

// Screen P-3 column definitions, $156F8 / 0x15708
// Modifies 1st, 2nd, 13th, 15th and 16th columns
	db $00,$02,$67,$70,$02,$67,$87,$70	// $00,$02
	db $02,$67,$70,$02,$02,$00,$00,$00	// $02,$00,$00,$13

//------------------------------------

// Screen A-4 column definitions, $15708 / 0x15718
	db $00,$00,$18,$94,$18,$18,$94,$18
	db $18,$94,$18,$18,$94,$18,$A3,$02

// Screen B-4 column definitions, $15718 / 0x15728
// Modified last two columns
	db $02,$A2,$18,$94,$18,$18,$94,$18
	db $18,$94,$18,$18,$94,$18,$16,$16	// $16,$16

// Screen C-4 column definitions, $15728 / 0x15738
// Modified 1st, 2nd and 13th columns
	db $F0,$F1,$A9,$C8,$C7,$A0,$06,$83
	db $A1,$A5,$A4,$C8,$C7,$A6,$01,$01	// $C7

// Screen D-4 column definitions, $15738 / 0x15748
// Modified 2nd & 14th columns
// Pending palette changes
	db $01,$A7,$02,$B7,$02,$B7,$B6,$B7	// $02
	db $02,$B7,$D2,$B7,$02,$B6,$00,$00	// $B6

// Screen E-4 column definitions, $15748 / 0x15758
// Modified 8th, 14th & 16th column
	db $00,$A9,$B7,$02,$B7,$02,$B7,$02	// $02
	db $07,$39,$47,$47,$47,$47,$91,$78	// $47,$78

// Screen F-4 column definitions, $15758 / 0x15768
	db $78,$78,$78,$78,$B8,$51,$97,$91
	db $51,$51,$51,$97,$91,$51,$51,$97

// Screen G-4 column definitions, $15768 / 0x15778
	db $91,$97,$58,$58,$91,$51,$97,$91
	db $97,$13,$13,$13,$13,$13,$13,$13	// $97,$13

// Screen H-4 column definitions, $15778 / 0x15788
// Modified 2nd, 3rd, 14th and 15th columns (Dungeon 1 Entrance)
	db $13,$00,$02,$64,$F2,$F3,$64,$65
	db $66,$E5,$D8,$66,$02,$02,$01,$12

// Screen I-4 column definitions, $15788 / 0x15798
	db $12,$12,$12,$12,$12,$12,$44,$18
	db $18,$17,$28,$17,$25,$17,$17,$15

// Screens J-4, C-5 & D-5 column definitions, $15798 / 0x157A8
// Modified 7th and 10th columns
	db $00,$A9,$02,$77,$02,$53,$54,$D1	// $54
	db $D1,$54,$56,$02,$77,$02,$A8,$00	// $54

// Screen K-4 column definitions, $157A8 / 0x157B8
// Modified 3rd & 16th columns
	db $00,$00,$C6,$C6,$C6,$C6,$C6,$C5	// $C6
	db $C5,$C6,$C6,$C6,$C6,$C6,$C6,$F9	// $F9

// Screen L-4 column definitions, $157B8 / 0x157C8
// Modified 1st & 12th columns
	db $F9,$C6,$C6,$C6,$C6,$C6,$C6,$C6	// $F9
	db $C6,$C6,$C6,$C6,$C5,$C5,$00,$00	// $C6

// Screen M-4 shared with L-1, $154B8 / 0x154C8

// Screen N-4 column definitions, $157C8 / 0x157D8
	db $15,$76,$26,$76,$26,$76,$49,$18
	db $18,$49,$76,$26,$76,$25,$76,$15

// Screen O-4 column definitions, $157D8 / 0x157E8
	db $00,$00,$D5,$08,$08,$08,$08,$08
	db $08,$35,$36,$36,$36,$36,$36,$36

// Screen P-4 column definitions, $157E8 / 0x157F8
// Modified 5th & 16th column
	db $36,$36,$36,$36,$36,$52,$D0,$52	// $36
	db $86,$E1,$13,$13,$13,$13,$13,$13	// $13

//------------------------------------

// Screen A-5 column definitions, $157F8 / 0x15808
// Modified 15th column
	db $00,$00,$D5,$93,$08,$08,$93,$08
	db $08,$93,$08,$08,$93,$08,$B5,$02	// $B5

// Screen B-5 column definitions, $15808 / 0x15818
// Modified 2nd, 14th, 15th and 16th columns
	db $02,$02,$08,$93,$08,$08,$93,$08	// $02
	db $08,$93,$08,$08,$93,$08,$15,$15	// $08,$15,$15

// Screen C-5 shared with J-4, $15798 / 0x157A8
// Screen D-5 shared with J-4, $15798 / 0x157A8

// Screen E-5 column definitions, $15818 / 0x15828
// Modified 8th column
	db $00,$A9,$02,$77,$10,$77,$02,$07	// $02,$07
	db $18,$45,$13,$13,$13,$13,$13,$13

// Screen F-5 column definitions, $15828 / 0x15838
// Modified 1st, 2nd, 3rd, 14th, 15th and 16th columns (Dungeon 4 Entrance)
	db $13,$00,$02,$02,$67,$70,$02,$67	// $13,$00,$02
	db $D7,$70,$02,$67,$70,$02,$00,$13	// $02,$00,$13

// Screen G-5 column definitions, $15838 / 0x15848
	db $13,$13,$13,$13,$13,$13,$43,$92
	db $52,$F7,$62,$62,$62,$62,$62,$62

// Screen H-5 column definitions, $15848 / 0x15858
	db $62,$62,$62,$62,$62,$62,$62,$62
	db $62,$62,$62,$F7,$62,$62,$62,$62

// Screen I-5 column definitions, $15858 / 0x15868
	db $62,$62,$62,$48,$48,$48,$41,$18
	db $18,$17,$17,$17,$17,$14,$15,$15

// Screen J-5 column definitions, $15868 / 0x15878
	db $15,$15,$17,$75,$17,$16,$16,$18
	db $18,$16,$16,$16,$16,$16,$16,$16

// Screen K-5 column definitions, $15878 / 0x15888
// Modified 7th & 10th columns
	db $F0,$F1,$A9,$A2,$A3,$77,$02,$08	// $02
	db $08,$02,$77,$10,$02,$A8,$F0,$F1	// $02

// Screen L-5 column definitions, $15888 / 0x15898
	db $16,$76,$27,$76,$76,$76,$26,$76
	db $25,$76,$15,$14,$18,$18,$15,$15

// Screen M-5 column definitions, $15898 / 0x158A8
	db $00,$F1,$A2,$A3,$A2,$A3,$A0,$83
	db $06,$06,$A1,$A2,$A3,$A6,$01,$A7

// Screen N-5 column definitions, $158A8 / 0x158B8
	db $16,$23,$25,$18,$25,$23,$26,$23
	db $23,$25,$23,$26,$18,$31,$23,$16

// Screen O-5 column definitions, $158B8 / 0x158C8
	db $16,$28,$17,$17,$17,$49,$17,$17
	db $17,$17,$49,$17,$17,$17,$28,$15

// Screen P-5 & P-6 column definitions, $158C8 / 0x158D8
	db $00,$00,$E6,$A1,$A2,$18,$18,$18
	db $18,$45,$12,$13,$12,$13,$13,$13

//------------------------------------

// Screen A-6 column definitions, $158D8 / 0x158E8
// Modified 3rd and 15th columns
	db $00,$00,$04,$04,$04,$04,$04,$04	// $04
	db $04,$04,$04,$04,$04,$04,$83,$00	// $83

// Screen B-6 column definitions, $158E8 / 0x158F8
	db $15,$28,$17,$25,$17,$25,$17,$25
	db $17,$31,$76,$76,$16,$16,$16,$16

// Screen C-6 column definitions, $158F8 / 0x15908
	db $16,$16,$17,$17,$30,$57,$57,$74
	db $74,$57,$57,$57,$57,$57,$30,$30

// Screen D-6 column definitions, $15908 / 0x15918
	db $30,$30,$17,$17,$76,$76,$31,$18
	db $18,$76,$27,$76,$17,$76,$28,$16

// Screen E-6 column definitions, $15918 / 0x15928
// Modified 15th column
	db $16,$16,$17,$76,$76,$26,$17,$23
	db $23,$46,$52,$48,$48,$52,$37,$37	// $37

// Screen F-6 column definitions, $15928 / 0x15938
// Modified 2nd,6th,7th & 15th column
	db $37,$37,$52,$52,$86,$13,$13,$92	// $37,$13,$13
	db $D0,$52,$36,$52,$36,$52,$37,$37	// $37

// Screen G-6 column definitions, $15938 / 0x15948
// Modified 3rd column
	db $37,$37,$37,$48,$48,$48,$41,$23	// $37
	db $23,$17,$31,$17,$25,$25,$17,$17

// Screen H-6 column definitions, $15948 / 0x15958
	db $17,$17,$17,$27,$17,$27,$17,$26
	db $17,$26,$17,$27,$17,$26,$17,$26

// Screen I-6 column definitions, $15958 / 0x15968
	db $26,$17,$26,$76,$27,$76,$26,$18
	db $18,$26,$76,$26,$76,$27,$76,$16

// Screen J-6 column definitions, $15968 / 0x15978
	db $16,$16,$16,$16,$16,$16,$16,$18
	db $18,$63,$42,$42,$42,$42,$42,$42

// Screen K-6 column definitions, $15978 / 0x15988
	db $42,$42,$42,$61,$61,$61,$60,$76
	db $76,$76,$76,$17,$17,$25,$76,$17

// Screen L-6 column definitions, $15988 / 0x15998
	db $17,$18,$31,$18,$18,$18,$25,$18
	db $25,$18,$26,$17,$18,$23,$17,$30

// Screen M-6 column definitions, $15998 / 0x159A8
	db $30,$30,$30,$30,$57,$29,$29,$29
	db $29,$29,$29,$29,$76,$16,$16,$16

// Screen N-6 column definitions, $159A8 / 0x159B8
	db $16,$16,$16,$18,$16,$16,$16,$16
	db $16,$16,$16,$16,$18,$16,$16,$16

// Screen O-6 column definitions, $159B8 / 0x159C8
	db $F1,$A9,$02,$02,$77,$A2,$A3,$10
	db $A8,$F0,$F1,$A9,$77,$02,$A8,$00

// Screen P-6 shared with P-5, $158C8 / 0x158D8

//------------------------------------

// Screen A-7 column definitions, $159C8 / 0x159D8
	db $15,$15,$23,$23,$23,$23,$23,$23
	db $23,$23,$23,$23,$23,$23,$28,$16

// Screen B-7 column definitions, $159D8 / 0x159E8
	db $16,$16,$16,$16,$16,$16,$16,$16
	db $16,$16,$18,$18,$16,$16,$16,$16

// Screen C-7 column definitions, $159E8 / 0x159F8
	db $16,$16,$16,$16,$16,$19,$18,$76
	db $14,$19,$19,$19,$19,$19,$28,$28

// Screen D-7 column definitions, $159F8 / 0x15A08
	db $28,$28,$17,$26,$23,$23,$31,$18
	db $18,$18,$26,$18,$27,$18,$28,$16

// Screen E-7 column definitions, $15A08 / 0x15A18
	db $F0,$F1,$A9,$08,$08,$A4,$77,$10
	db $A5,$08,$08,$A4,$A5,$08,$A4,$02

// Screen F-7 column definitions, $15A18 / 0x15A28
// Modified 6th and 7th columns
	db $02,$A5,$08,$E3,$18,$12,$12,$08	// $12,$12
	db $08,$08,$33,$08,$32,$08,$A4,$02

// Screen G-7 column definitions, $15A28 / 0x15A38
	db $02,$02,$02,$33,$33,$33,$33,$10
	db $32,$32,$32,$E8,$07,$07,$A8,$F0

// Screen H-7 column definitions, $15A38 / 0x15A48
// Modified 7th column
	db $F1,$A9,$02,$33,$02,$33,$02,$D3	// $02
	db $07,$A8,$A9,$02,$33,$02,$A8,$F0

// Screen I-7 column definitions, $15A48 / 0x15A58
	db $F1,$A9,$31,$18,$26,$18,$27,$18
	db $18,$26,$18,$27,$18,$26,$18,$16

// Screen J-7 column definitions, $15A58 / 0x15A68
	db $16,$28,$25,$17,$17,$26,$17,$23
	db $23,$40,$48,$48,$48,$48,$48,$48

// Screen K-7 column definitions, $15A68 / 0x15A78
	db $48,$48,$48,$48,$48,$48,$41,$23
	db $23,$23,$23,$17,$31,$17,$23,$17

// Screen L-7 column definitions, $15A78 / 0x15A88
	db $17,$23,$25,$23,$23,$23,$25,$23
	db $31,$23,$26,$76,$18,$76,$28,$16

// Screen M-7 column definitions, $15A88 / 0x15A98
	db $16,$16,$16,$16,$19,$14,$28,$17
	db $17,$17,$17,$17,$23,$30,$30,$30

// Screen N-7 column definitions, $15A98 / 0x15AA8
	db $30,$30,$17,$23,$29,$29,$29,$29
	db $29,$29,$14,$29,$19,$16,$16,$16

// Screen O-7 column definitions, $15AA8 / 0x15AB8
	db $16,$28,$17,$26,$26,$26,$17,$27
	db $27,$17,$25,$25,$25,$25,$17,$17

// Screen P-7 column definitions, $15AB8 / 0x15AC8
	db $A3,$02,$02,$10,$A2,$18,$18,$18
	db $18,$45,$13,$13,$13,$13,$13,$13

//------------------------------------

// Screen A-8 column definitions, $15AC8 / 0x15AD8
	db $00,$A7,$F1,$A9,$02,$64,$F2,$F3
	db $64,$F2,$F3,$10,$02,$02,$02,$02

// Screen B-8 column definitions, $15AD8 / 0x15AE8
	db $02,$02,$02,$A5,$A4,$D2,$02,$02
	db $02,$A5,$08,$08,$A4,$A8,$F0,$F1

// Screen C-8 column definitions, $15AE8 / 0x15AF8
	db $16,$16,$F4,$F4,$F4,$F4,$74,$74
	db $30,$30,$30,$30,$30,$30,$30,$30

// Screen D-8 column definitions, $15AF8 / 0x15B08
	db $30,$30,$30,$30,$30,$30,$30,$23
	db $23,$23,$27,$23,$17,$23,$28,$16

// Screen E-8 column definitions, $15B08 / 0x15B18
	db $F1,$A9,$02,$02,$B7,$02,$B7,$67
	db $F5,$70,$B7,$02,$B7,$02,$A8,$00

// Screen F-8 column definitions, $15B18 / 0x15B28
// Modified 6th and 7th columns
	db $00,$A9,$10,$C0,$E3,$13,$13,$A3	// $13,$13
	db $33,$02,$32,$02,$33,$02,$02,$02

// Screen G-8 column definitions, $15B28 / 0x15B38
// Modified 14th column
	db $02,$02,$34,$02,$02,$34,$D2,$02
	db $33,$02,$32,$A5,$08,$08,$F0,$A6	// $08

// Screen H-8 column definitions, $15B38 / 0x15B48
// Modified 15th column
	db $01,$A7,$84,$90,$10,$02,$A5,$08	// $84,$90
	db $08,$A0,$06,$06,$06,$06,$01,$01	// $06,$01

// Screen I-8 column definitions, $15B48 / 0x15B58
	db $A7,$F1,$25,$23,$31,$23,$26,$23
	db $23,$26,$23,$26,$23,$26,$23,$17

// Screen J-8 column definitions, $15B58 / 0x15B68
	db $A3,$C8,$C7,$A0,$E7,$E6,$A2,$A3
	db $71,$32,$34,$02,$A8,$A6,$01,$01

// Screen K-8 shared with G-1 & I-1, $15478 / 0x15488

// Screen L-8 column definitions, $15B68 / 0x15B78
// Modified 11th & 15th columns 
	db $01,$A7,$A6,$01,$A7,$F1,$A9,$39
	db $47,$85,$47,$58,$58,$58,$47,$47	// $47,$47

// Screen M-8 & N-8 column definitions, $15B78 / 0x15B88
	db $47,$47,$47,$47,$47,$47,$85,$47
	db $47,$47,$47,$47,$47,$47,$47,$47

// Screen O-8 column definitions, $15B88 / 0x15B98
// Modified 2nd column
	db $47,$47,$91,$51,$97,$91,$51,$51	// $47
	db $51,$97,$91,$51,$97,$91,$97,$91

// Screen P-8 column definitions, $15B98 / 0x15BA8
	db $97,$91,$51,$51,$97,$58,$58,$58
	db $F6,$E0,$13,$13,$13,$13,$13,$13

//------------------------------------

// Caves (Old Man/Woman, Secret Moblin, etc.) Screen column definitions, $15BA8 / 0x15BB8
	db $00,$00,$95,$95,$95,$95,$95,$C2
	db $C2,$95,$95,$95,$95,$95,$00,$00

// Secret Passages caves Screen column definitions, $15BB8 / 0x15BC8
	db $00,$00,$95,$95,$95,$F8,$95,$C2
	db $F8,$95,$95,$F8,$95,$95,$00,$00

// Lake with Dead Trees Screen column definitions, $15BC8 / 0x15BD8
	db $00,$A9,$64,$66,$02,$53,$54,$D1
	db $54,$54,$56,$02,$64,$66,$A8,$00

// Screens $7C to $7F are undefined



