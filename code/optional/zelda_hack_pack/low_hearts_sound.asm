;
; 	Low Hearts Heartbeat Sound
;	(gzip's Zelda Hack Pack)
;------------------------------------
; Modify the low heart beeping sound to be more soft, like a heartbeat kind-of sound

; Original sound bytes - 95 50 08 08 08 08 08 90
%org($9862,0)		; 0x01872
	db $9C,$80,$80,$08,$08,$08,$08,$08
