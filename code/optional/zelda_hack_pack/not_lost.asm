;
; 	Not Lost (Woods & Hills)
;	(gzip's Zelda Hack Pack)
;------------------------------------
; Make the Lost Woods & Lost Hills just a normal screen instead of having to always walk the correct path to go through

; Change the Lost Woods map location in the code so it never triggers
%org($ADA6,1)		; 0x6DB6
	cpy #$FF	; Originally CPY #$61

; Change the Lost Hills map location in the code so it never triggers
%org($ADC8,1)		; 0x6DD8
	cpy #$FF	; Originally CPY #$1B
