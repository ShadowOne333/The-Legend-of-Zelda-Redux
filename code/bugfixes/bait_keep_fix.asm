;
; Source:
; 	The3Dude
; 
; License:
; 	Code should be used only for educational, documentation and modding purposes.
; 	Please keep derivative work open source.
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; Ensure the Bait item is removed from the inventory at the exact time it is given
%org($8C88,1)		; 0x04C98
	jmp bait_keep_fix
	nop #2

%org($8CB0,1)		; 0x04CC0
bait_keep_fix:
	lda #$00	; Load 0 into accumulator
	sta $065D	; InvFood, remove food item from the inventory in RAM
	lda #$04	; Load 4 into accumulator (track ID)
	sta $0602	; Tune 1 request
	jmp $8C8D	; Return back to the original hijack code
	;rts		; This isn't necessary since we're jumping back to the original code
