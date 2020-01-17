//****************************************
// Table file
//****************************************
table code/text.tbl,ltr

//****************************************
// Control codes
//****************************************
define	end	$FF  // end

//****************************************
// Credits text pointers
//****************************************
bank 2;
org $AC43  // $0AC53
    db $D2, $E9  
// Changes the pointers to both "THE LEGEND OF ZELDA" and the "(C)Nintendo 1986" texts
// from $ADD1 to $ADD2 and from $ADEA to $ADE


//****************************************
// Credits and Post-credits text
//****************************************
org $AC5C  // $0AC6C
// Length, X Position, "Text"
    db $07, $0D, " STAFF "  //07 0D 24 1C 1D 0A 0F 0F 24
    db $09, $05, "EXECUTIVE"  //09 05 0E 21 0E 0C 1E 1D 12 1F 0E
    db $16, $05, "PRODUCER... H.YAMAUCHI"  //16 05 19 1B 18 0D 1E 0C 0E 1B 63 63 63 24 11 63 22 0A 16 0A 1E 0C 11 12
    db $16, $05, "PRODUCER... S.MIYAMOTO"  //16 05 19 1B 18 0D 1E 0C 0E 1B 63 63 63 24 1C 2C 16 12 22 0A 16 18 1D 18
    db $16, $05, "DIRECTOR... S.MIYAMOTO"  //16 05 0D 12 1B 0E 0C 1D 18 1B 63 63 2C 24 1C 2C 16 12 22 0A 16 18 1D 18
    db $0E, $0D, "..... T.TEZUKA"  //0E 0D 63 63 63 63 63 24 1D 2C 1D 0E 23 1E 14 0A
    db $16, $05, "DESIGNER..... T.TEZUKA"  //16 05 0D 0E 1C 12 10 17 0E 1B 63 2C 2C 2C 2C 24 1D 2C 1D 0E 23 1E 14 0A
    db $16, $05, "PROGRAMMER... T.NAKAGO"  //16 05 19 1B 18 10 1B 0A 16 16 0E 1B 63 63 2C 24 1D 2C 17 0A 14 0A 10 18
    db $0C, $0F, ".. Y.SOEJIMA"  //0C 0F 63 63 24 22 2C 1C 18 0E 13 12 16 0A
    db $0C, $0F, " T.NISHIYAMA"  //0C 0F 24 1D 2C 17 12 1C 11 12 22 0A 16 0A
    db $05, $05, "SOUND"  //05 05 1C 18 1E 17 0D
    db $16, $05, "COMPOSER... KOJI KONDO"  //16 05 0C 18 16 19 18 1C 0E 1B 63 63 63 24 14 18 13 12 24 14 18 17 0D 18

    db $18, $04, "ANOTHER QUEST WILL START"  //18 04 0A 17 18 1D 11 0E 1B 24 1A 1E 0E 1C 1D 24 20 12 15 15 24 1C 1D 0A 1B 1D
    db $0A, $0B, "FROM HERE."  //0A 0B 0F 1B 18 16 24 11 0E 1B 0E 2C
    db $17, $05, "PRESS THE START BUTTON."  //17 05 19 1B 0E 1C 1C 24 1D 11 0E 24 1C 1D 0A 1B 1D 24 0B 1E 1D 1D 18 17 2C
    db $0E, $09, $FC,"1986 NINTENDO"  //0E 09 FC 01 09 08 06 24 17 12 17 1D 0E 17 0D 18

    db $0E, $09, "YOU ARE GREAT!"  //0E 09 22 18 1E 24 0A 1B 0E 24 10 1B 0E 0A 1D 29
    db $0D, $09, "         ", $62, "   "  //0D 09 24 24 24 24 24 24 24 24 24 62 24 24 24
    db $13, $06, "YOU HAVE AN AMAZING"  //13 06 22 18 1E 24 11 0A 1F 0E 24 0A 17 24 0A 16 0A 23 12 17 10
    db $11, $08, "WISDOM AND POWER!"  //11 08 20 12 1C 0D 18 16 24 0A 17 0D 24 19 18 20 0E 1B 29
    db $07, $0C, "THE END" //07 0C 1D 11 0E 24 0E 17 0D
    db $15, $05, $2D, "THE LEGEND OF ZELDA", $2D  //15 05 2D 1D 11 0E 24 15 0E 10 0E 17 0D 24 18 0F 24 23 0E 15 0D 0A 2D
    db $0E, $09, $FC,"1986 NINTENDO", {end}  //0E 09 FC 01 09 08 06 24 17 12 17 1D 0E 17 0D 18 FF
