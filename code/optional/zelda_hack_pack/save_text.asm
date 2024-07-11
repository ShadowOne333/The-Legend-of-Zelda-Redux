.PATCH 05:B74B
  LDA #$3E                   ; bump selected item down 8px (was $36)

; repoint hud tile buffers
.PATCH 06:A032
  .data save_text            ; this needs to come early so it doesn't get wiped out
  .data b_button_box
  .data $A202                ; (ganon palette)
  .data box_tops
  .data box_sides
  .data box_bottoms

; repoint hud attr table buffer
.PATCH 06:A048
  .data hud_attr_table_overwrite
  .data hud_attr_table_2

; new ppu location for inventory text
.PATCH 06:A316
  .data $29, $51

; map top and bottom edges
.PATCH 06:A323
start_buffers:
  box_tops:
    .data $29, $C5, $03, $69, $6A, $6B ; b box top
    .data $29, $CF, $01, $69 ; tl corner
    .data $29, $D0, $4B, $6A ; top run
    .data $29, $DB, $01, $6B ; tr corner
    .data $FF
  b_button_box:
    .data $29, $E5, $06, $6C, $0B, $6E, $6A, $6A, $6B
    .data $FF
  box_sides:
    .data $2A, $27, $01, $6C ; b box left side
    .data $2A, $0A, $C2, $6C ; selected right side
    .data $29, $EF, $C4, $6C ; inventory left side vertical
    .data $29, $FB, $C4, $6C ; inventory right side vertical
    .data $FF
  box_bottoms:
    ; b box
    .data $2A, $05, $03, $6E, $6A, $6B
    ; selected box
    .data $2A, $47, $04, $6E, $6A, $6A, $6D
    ; inventory box
    .data $2A, $6F, $01, $6E ; bl corner
    .data $2A, $70, $4B, $6A ; bottom run
    .data $2A, $7B, $01, $6D ; br corner
    .data $FF
end_buffers:

; make sure we don't overflow the available freespace
.if end_buffers - start_buffers > $55
  .error Overflow
.endif

; top and bottom edges of map
.PATCH 06:A388
  map_top_edge:
    .data $2A, $8C, $10, $FD, $F5, $FD, $F5, $F5, $FD, $F5, $F5, $F5, $F5, $F5, $F5, $FD, $F5, $F5, $FD, $FF
  map_bottom_edge:
    .data $2B, $AC, $10, $FE, $FE, $F5, $F5, $F5, $F5, $FE, $F5, $F5, $F5, $FE, $F5, $F5, $F5, $FE, $FE, $FF
  hud_attr_table_1:          ; ditch this for the override above
    .data $2B, $D9, $43, $05
    .data $2B, $DC, $4B, $00
    .data $FF
  hud_attr_table_2:
    .data $2B, $E9, $56, $55
    .data $FF

; add replacement buffers in free space
.PATCH 06:AF30
  save_text:
    .data $29, $63, $04, $1E, $19, $2B, $0A
    .data $29, $83, $07, $1D, $18, $24, $1C, $0A, $1F, $0E
    .data $FF
  hud_attr_table_overwrite:
    .data $2B, $D0, $0B, $55, $55, $00, $00, $55, $55, $55, $00, $05, $05, $05
    .data $2B, $DB, $4C, $00
    .data $FF
