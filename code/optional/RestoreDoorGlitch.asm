;------------------------------------
; Restore the Dungeon 1 Door Glitch
;------------------------------------

; Reset dungeon room door flags
%org($B4A5,5)		; 0x174B5
	sta $0526

