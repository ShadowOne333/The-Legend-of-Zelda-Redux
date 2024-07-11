bank 5; org $B74B
  lda.b #$3E                 // bump selected item down 8px (was $36)

// repoint hud tile buffers
bank 6; org $A032
  dw .save_text              // this needs to come early so it doesn't get wiped out
  dw .b_button_box
  dw $A202                   // (ganon palette)
  dw .box_tops
  dw .box_sides
  dw .box_bottoms

// repoint hud attr table buffer
bank 6; org $A048
  dw .hud_attr_table_overwrite
  dw .hud_attr_table_2

// new ppu location for inventory text
bank 6; org $A316
  db $29, $51

// map top and bottom edges
bank 6; org $A323
  .box_tops:
    db $29, $C5, $03, $69, $6A, $6B // b box top
    db $29, $CF, $01, $69 // tl corner
    db $29, $D0, $4B, $6A // top run
    db $29, $DB, $01, $6B // tr corner
    db $FF
  .b_button_box:
    db $29, $E5, $06, $6C, $0B, $6E, $6A, $6A, $6B
    db $FF
  .box_sides:
    db $2A, $27, $01, $6C // b box left side
    db $2A, $0A, $C2, $6C // selected right side
    db $29, $EF, $C4, $6C // inventory left side vertical
    db $29, $FB, $C4, $6C // inventory right side vertical
    db $FF
  .box_bottoms:
    // b box
    db $2A, $05, $03, $6E, $6A, $6B
    // selected box
    db $2A, $47, $04, $6E, $6A, $6A, $6D
    // inventory box
    db $2A, $6F, $01, $6E // bl corner
    db $2A, $70, $4B, $6A // bottom run
    db $2A, $7B, $01, $6D // br corner
    db $FF

// top and bottom edges of map
bank 6; org $A388
  .map_top_edge:
    db $2A, $8C, $10, $FD, $F5, $FD, $F5, $F5, $FD, $F5, $F5, $F5, $F5, $F5, $F5, $FD, $F5, $F5, $FD, $FF
  .map_bottom_edge:
    db $2B, $AC, $10, $FE, $FE, $F5, $F5, $F5, $F5, $FE, $F5, $F5, $F5, $FE, $F5, $F5, $F5, $FE, $FE, $FF
  .hud_attr_table_1:         // ditch this for the override above
    db $2B, $D9, $43, $05
    db $2B, $DC, $4B, $00
    db $FF
  .hud_attr_table_2:
    db $2B, $E9, $56, $55
    db $FF

// add replacement buffers in free space
bank 6; org $AF30
  .save_text:
    db $29, $63, $04, $1E, $19, $2B, $0A
    db $29, $83, $07, $1D, $18, $24, $1C, $0A, $1F, $0E
    db $FF
  .hud_attr_table_overwrite:
    db $2B, $D0, $0B, $55, $55, $00, $00, $55, $55, $55, $00, $05, $05, $05
    db $2B, $DB, $4C, $00
    db $FF
