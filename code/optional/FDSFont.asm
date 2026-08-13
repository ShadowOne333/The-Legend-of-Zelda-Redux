;***********************************************************
;	FDS Font and characters
;***********************************************************

; Import Famicom Disk System font and characters
%org($877F,2)		; 0x0878F-0x08E8F
	incbin "code/optional/fds_font/fds_font.chr"
; Infinity symbol (+840 bytes)
%org($8DBF,2)		; 0x08DCF
	incbin "code/optional/fds_font/infinity_symbol.chr"
