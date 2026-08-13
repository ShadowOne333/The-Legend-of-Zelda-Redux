;***********************************************************
;	Link's Awakening DX Graphics
;***********************************************************

; Title screen and Intro graphics
%org($8DB4,1)		; 0x04DC4-0x06003
	incbin "code/optional/la_gfx/la_gfx00a.bin"
	incbin "code/optional/la_gfx/la_gfx00b.bin"

; Link, items, HUD and Font sprites 
%org($807F,2)		; 0x0808F-0x0900F
	incbin "code/optional/la_gfx/la_gfx01a.bin"
	incbin "code/optional/la_gfx/la_gfx01b.bin"
	incbin "code/optional/la_gfx/la_gfx01c.bin"

; Dungeon and overworld tiles
%org($811B,3)		; 0x0C12B-0x0D12A
	incbin "code/optional/la_gfx/la_gfx02a.bin"
	incbin "code/optional/la_gfx/la_gfx02b.bin"
; NPC and enemy sprites
%org($915B,3)		; 0x0D16B-0x0EBEF
	incbin "code/optional/la_gfx/la_gfx03a.bin"
	incbin "code/optional/la_gfx/la_gfx03b.bin"
	incbin "code/optional/la_gfx/la_gfx03c.bin"
	incbin "code/optional/la_gfx/la_gfx03d.bin"
	incbin "code/optional/la_gfx/la_gfx03e.bin"
	incbin "code/optional/la_gfx/la_gfx03f.bin"
	incbin "code/optional/la_gfx/la_gfx03g.bin"
	incbin "code/optional/la_gfx/la_gfx03h.bin"
; Overworld Cracked Walls and Burnable Tree
%org($AC60,3)		; 0x0EC70
	incbin "code/optional/la_gfx/OverworldAssets.bin"
; Dungeons Cracked Walls
	incbin "code/optional/la_gfx/DungeonAssets.bin"

; MMC1 Animated tiles frames
%org($AEA0,3)		; 0x0EEB0
	incbin "code/optional/la_gfx/ow_1st_frame1.chr"
	incbin "code/optional/la_gfx/ow_2nd_frame1.chr"
	incbin "code/optional/la_gfx/ow_1st_frame2.chr"
	incbin "code/optional/la_gfx/ow_2nd_frame2.chr"
	incbin "code/optional/la_gfx/ow_1st_frame3.chr"
	incbin "code/optional/la_gfx/ow_2nd_frame3.chr"

; Change brown colour of Link to have more contrast
; Overworld palette
%org($9313,6)		; 0x19323
	db $0F,$29,$27,$07	; Black, green, beige, brown
; Dungeons palettes
%org($940F,6)		; 0x1941F
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($950B,6)		; 0x1951B
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($9607,6)		; 0x19617
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($9703,6)		; 0x19713
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($97FF,6)		; 0x1980F
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($98FB,6)		; 0x1990B
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($99F7,6)		; 0x19A07
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($9AF3,6)		; 0x19B03
	db $0F,$29,$27,$07	; Black, green, beige, brown
%org($9BEF,6)		; 0x19BFF
	db $0F,$29,$27,$07	; Black, green, beige, brown

; Change palette of Link on File Select screen
%org($9CEB,6)		; 0x19CFB
	db $0F,$29,$27,$07	; Black, green, beige, brown
	db $0F,$22,$27,$07	; Black, blue, beige, brown
	db $0F,$16,$27,$07	; Black, red, beige, brown
