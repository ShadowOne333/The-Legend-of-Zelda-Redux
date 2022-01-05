//****************************************
// Increase initial max bombs from 8 to 10
//****************************************
bank 2; org $9F4B	// 0x09F5B
	lda.b #$0A	// Originally A9 08 (LDA $08)
// Max bomb amount when finishing 1st Quest and starting 2nd Quest
	org $AF83	// 0x0AF93
	lda.b #$0A

//****************************************
// Increase bomb upgrades from 4 to 10
//****************************************
bank 1; org $8B8A	// 0x04B9A
	adc.b #$0A	// Originally 69 04 (ADC #$04)

//****************************************
// Increase obtained bombs from drops to 5
//****************************************
org $6C51	// 0x06C61
	jmp $6CEE	// BombCheck-0X656E-PRG $6CEE ($655E+790)
	nop #05

org $655E	// 0x0656E
BombCheck:
	lda.b $0A
	cmp.b #$04
	bne keys
	lda.b #$05
keys:
	clc
	adc.w $0657,y
	bcc back
	jmp $73E9	// 6C59
back:
	jmp $73EB	// 6C5B
