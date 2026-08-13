;****************************************
;   Remove THE HYRULE FANTASY subtitle
;****************************************

; HYRULE FANTASY Tiles
; ———————————————
%org($AA15,6)		; 0x1AA25
	db $E2,$24,$24,$24,$24,$24,$24,$24,$C1,$C2,$C3
	db $C4,$C5,$24,$24,$24,$24,$24,$24,$24,$24,$E3
; Attribute table
%org($AC9F,6)		; 0x1ACAF
	db $6E,$5F,$55,$5D,$DF,$BB
