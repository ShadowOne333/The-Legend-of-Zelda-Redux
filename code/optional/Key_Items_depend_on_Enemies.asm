; All Key Items depend on All On-Screen Enemies being defeated to appear

;------------------------------------------------------------------

; There are rooms that have an item in plain sight and the enemies in the room don't need to be defeated in order to obtain said item. Such as a map, compass, key, or bombs.
; For example, in Level 3, you have one room with Zols and a key in plain sight.
; Then in the very next room you face more Zols, but in order to get the key in that room, they must all be defeated.
; There are rooms like that here and there, which gives the impression that the rooms with items in plain sight were not intentional (or maybe it was but it's always bugged me either way).
; The Wallmaster is probably the only enemy type to makes sense to have the item in plain sight near a wall.

;------------------------------------------------------------------
; LEVEL 1 (Q1) CHANGES

; Defeat Keese to get the Compass 
%org($89D4,6)		; 0x189E4
	db $07
; Defeat Gels to get the Map
%org($89C3,6)		; 0x189D3
	db $07
; Defeat Wallmasters to get the Key
%org($89C5,6)		; 0x189D5
	db $17
;------------------------------------------------------------------
; LEVEL 2 (Q1) CHANGES

; Defeat Gels to get the Compass
%org($89EF,6)		; 0x189FF
	db $17
; Defeat Gels to get the Map
%org($89DF,6)		; 0x189EF
	db $07
; Defeat Keese to get Bombs
%org($89BF,6)		; 0x189CF
	db $07
;------------------------------------------------------------------
; LEVEL 3 (Q1) CHANGES

; Defeat Zols to get the Key
%org($89FB,6)		; 0x18A0B
	db $07
; Defeat Keese to get the Compass
%org($89CA,6)		; 0x189DA
	db $07
; Defeat Keese & Zols to get the Key
%org($89C9,6)		; 0x189D9
	db $07
; Defeat Keese to get the Key
%org($89AA,6)		; 0x189BA
	db $07
; Defeat Zols to get Map
%org($89CC,6)		; 0x189DC
	db $07
;------------------------------------------------------------------
; LEVEL 4 (Q1) CHANGES

; Defeat Vires to get Compass
%org($89E2,6)		; 0x189F2
	db $27
; Defeat Keese to get Key 1 
%org($89D1,6)		; 0x189E1
	db $17
; Defeat Zols to get Key
%org($89C0,6)		; 0x189D0
	db $27
; Defeat Zols to get Map
%org($89A1,6)		; 0x189B1
	db $07
; Defeat Keese to get Key 2
%org($8981,6)		; 0x18991
	db $27
;------------------------------------------------------------------
; LEVEL 5 (Q1) CHANGES

; Defeat Keese to get Key
%org($89AA,6)		; 0x189BA
	db $27
; Defeat Gibdos, Pols Voice, Keese to get Key
%org($89A7,6)		; 0x189B7
	db $27
;------------------------------------------------------------------
; LEVEL 6 (Q1) CHANGES

; Defeat Wizzrobes to get Key 1
%org($89A9,6)		; 0x189B9
	db $07
; Defeat Wizzrobes to get Key 2
%org($899A,6)		; 0x189AA
	db $07
;------------------------------------------------------------------
; LEVEL 7 (Q1) CHANGES

; Defeat Ropes to get Key
%org($8CF8,6)		; 0x18D08
	db $07
; Defeat Stalfos to get Compass
%org($8CDA,6)		; 0x18CEA
	db $07
; Defeat All to get Map
%org($8C98,6)		; 0x18CA8
	db $07
;------------------------------------------------------------------
; LEVEL 8 (Q1) CHANGES

; Defeat All to get Key
%org($8CFF,6)		; 0x18D0F
	db $07
; Defeat Pols Voice to get Compass
%org($8CDF,6)		; 0x18CEF
	db $07
; Defeat Darknuts to get Key
%org($8CCB,6)		; 0x18CDB
	db $07
;------------------------------------------------------------------
; LEVEL 9 (Q1) CHANGES

; Defeat Gels to get Bombs
%org($8CA3,6)		; 0x18CB3
	db $17
; Defeat Patra to get Key
%org($8CE1,6)		; 0x18CF1
	db $17
; Defeat Wizzrobes to get Key
%org($8CC7,6)		; 0x18CD7
	db $17
;------------------------------------------------------------------

