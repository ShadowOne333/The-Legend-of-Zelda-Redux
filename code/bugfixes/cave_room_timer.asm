;
; Source:
; 	minucce
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Reset timer for cave start
%org($886A,5)		; 0x1487A
	jsr $85E4	; Our custom routine at free space 0x145F4
	nop #3

%org($85F0,5)		; 0x14600
	sta $AC,x
	sta $98,x
	sta $3D,x
	sta $28,x	; Added fix from the Famicom release
	rts
