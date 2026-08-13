;****************************************
; Increase bomb upgrades from 4 to 5
;****************************************
%org($8B8A,1)		; 0x04B9A
	adc  #$05	; Originally 69 04 (ADC #$04)
