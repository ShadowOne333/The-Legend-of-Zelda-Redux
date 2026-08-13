;***********************************************************
;	Manual save by pressing Up+A on Pause
;***********************************************************

; Button values for remapping purposes:
; FOR RAM ADDRESSES LOADED FROM $F5/$F7

; 01 = D-Pad Right	| 02 = D-Pad Left
; 04 = D-Pad Down	| 08 = D-Pad Up
; 10 = Start Button	| 20 = Select Button
; 40 = B Button	| 80 = A Button

;***********************************************************
;	Control codes
;***********************************************************

!HOLD_PAD_1	= $FA

;------------------------------------
; Save manually by pressing Up+A on 
; Change button combo by modifying the #$88 to whatever combination is desired from the values posted above
%org($80DA,5)		; 0x140EA
	lda !HOLD_PAD_1		; Originally LDA $FB, Controller 2
	and #$88		; Press Up+A to save (Change to $20 for Select to save)
	cmp #$88		; Press Up+A to save (Change to $20 for Select to save)
