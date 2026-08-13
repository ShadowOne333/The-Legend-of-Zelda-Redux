;***********************************************************
;	Palette changes
;***********************************************************

;***********************************************************
;	Make Blue tunic more vivid 
;***********************************************************

%org($AB95,1)		; 0x6BA5
	db $29,$22,$16	; Green, blue, red

%org($A287,2)		; 0xA297
	db $29,$22,$16	; Green, blue, red

;***********************************************************
;	Modify Ganon's palette to match artwork
;***********************************************************

; If Ganon is left idle during his Arrow-vulnerable state, if he goes back to his moving state, he reverts to the original palette.
; This forces the palette to be the same.
%org($AF67,4)		; 0x12F77
	db $06,$22,$30		; Originally 16 2C 3C

; Normal palette when first encountering Ganon.
%org($A205,6)		; 0x1A215
	db $0F,$06,$22,$30	; Originally 0F 16 2C 3C

;***********************************************************
;		Photosensitivity patches
;***********************************************************

; Attenuate Ending flash
%org($AA1F,2)		; 0xAA2F
	db $0F,$02,$06,$0A	; Originally 0F 12 16 2A

; Attenuate Triforce Get flash
%org($A272,6)		; 0x1A282
	db $3F,$08,$08
	db $0F,$2D,$2D,$10	; Originally 0F 30 30 30 (Triforce)
	db $0F,$2D,$2D,$10	; Originally 0F 30 30 30 (Ganon)
	db $FF

;***********************************************************
;	Aquamentus color change from Green to Red
;***********************************************************

;%org($A291,6)		; 0x1A29E
;	db $0F,$13,$16,$35

