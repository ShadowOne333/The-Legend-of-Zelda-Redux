;****************************************
; Increase initial max bombs from 8 to 10
;****************************************
%org($9F4B,2)		; 0x09F5B
	lda #$0A	; Originally A9 08 (LDA $08)
; Max bomb amount when finishing 1st Quest and starting 2nd Quest
%org($AF83,2)		; 0x0AF93
	lda #$0A

;****************************************
; Increase bomb upgrades from 4 to 10
;****************************************
%org($8B8A,1)		; 0x04B9A
	adc #$0A	; Originally 69 04 (ADC #$04)

;****************************************
; Increase obtained bombs from drops to 5
;****************************************
%org($AC51,1)		; 0x06C61
	jmp $6CEE	; BombCheck-0X656E-PRG $6CEE ($655E+790)
	nop #05

%org($A55E,1)		; 0x0656E
BombCheck:
	lda $0A
	cmp #$04
	bne keys
	lda #$05
keys:
	clc
	adc $0657,y
	bcc back
	jmp $73E9	; 6C59
back:
	jmp $73EB	; 6C5B
