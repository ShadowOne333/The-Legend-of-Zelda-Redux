//****************************************
// table file
//****************************************
table code/text.tbl

//****************************************
// control codes
//****************************************
// ..xx xxxx    Letter Code
// .x.. ....    Start third line of text (after letter)
// x... ....    Start second line of text (after letter)
// Text ends when a byte has bits 6-7 set.
define line_1  $80  // line break
define line_2  $40  // line break
define end     $C0  // end


//****************************************
// text pointers
//****************************************
bank 1; org $8000  // $04010
    dw text_00, text_01, text_02, text_03
    dw text_04, text_05, text_06, text_07
    dw text_08, text_09, text_10, text_11
    dw text_12, text_13, text_14, text_15
    dw text_36, text_16, text_17, text_18
    dw text_19, text_20, text_21, text_22
    dw text_23, text_24, text_25, text_26
    dw text_27, text_28, text_29, text_30
    dw text_31, text_32, text_33, text_37
    dw text_34, text_35


//****************************************
// dialogue
//****************************************

text_00:
	db "__IT'S DANGEROUS TO G", 'O'|{line_1}
	db "____ALONE! TAKE THIS",  '.'|{end}

//----------------------------------------

text_01:
	db "__BECOME STRONGER AN", 'D'|{line_1}
	db "___YOU MAY HAVE THIS", '.'|{end}

//----------------------------------------

text_02:
	db "_TAKE ANY PATH YOU WANT", '.'|{end}

//----------------------------------------

text_03:
	db "_THERE'S A SECRET IN ", 'A'|{line_1}
	db "__TREE AT A DEAD-END",  '.'|{end}

//----------------------------------------

text_04:
	db "_____WANT TO PLAY ",   'A'|{line_1}
	db "___MONEY-MAKING GAME", '?'|{end}

//----------------------------------------

text_05:
	db "____YOU OWE ME FO",   'R'|{line_1}
	db "___THE DOOR REPAIRS", '.'|{end}

//----------------------------------------

text_06:
	db "____SHOW THIS TO TH", 'E'|{line_1}
	db "_______OLD WOMAN",    '.'|{end}

//----------------------------------------

text_07:
	db "____MEET THE OLD MA",  'N'|{line_1}
	db "____AT THE GRAVEYARD", '.'|{end}

//----------------------------------------

text_08:
	db "____BUY MEDICINE AN", 'D'|{line_1}
	db "_____BE ON YOUR WAY", '.'|{end}

//----------------------------------------

text_09:
	db "_I WON'T TALK FOR FREE", '!'|{end}

//----------------------------------------

text_10:
	db "___THIS ISN'T ENOUG", 'H'|{line_1}
	db "____TO MAKE ME TALK", '.'|{end}

//----------------------------------------

text_11:
	db "_______GO WAY U",       'P'|{line_1}
	db "___THE MOUNTAIN AHEAD", '.'|{end}

//----------------------------------------

text_12:
	db "__GO NORTH,WEST,SOUTH", ','|{line_1}
	db "__WEST IN THE LOS",     'T'|{line_2}
	db "__WOODS",               '.'|{end}

//----------------------------------------

text_13:
	db "___YOU SURE ARE RICH", '!'|{end}

//----------------------------------------

text_14:
	db "_BUY SOMETHIN' WILL YA", '!'|{end}

//----------------------------------------

text_15:
	db "__THIS IS A GOOD VALU", 'E'|{line_1}
	db "___AND WORTH BUYING",   '.'|{end}

//----------------------------------------

text_16:
	db "_____IT'S A SECRE", 'T'|{line_1}
	db "_____TO EVERYBODY", '.'|{end}

//----------------------------------------

text_17:
	db "___GRUMBLE,GRUMBLE..", '.'|{end}

//----------------------------------------

text_18:
	db "__YOU CAN'T USE ARROW", 'S'|{line_1}
	//db "_YOU RUN OUT OF MONEY",   '.'|{end}
	db "_____WITHOUT A BOW",   '.'|{end}

//----------------------------------------

text_19:
	db "__DODONGOS HATE SMOKE", '.'|{end}

//----------------------------------------

text_20:
	db "_DID YOU GET THE SWOR", 'D'|{line_1}
	db "_FROM THE OLD MAN O",   'N'|{line_2}
	db "_TOP OF THE WATERFALL", '?'|{end}

//----------------------------------------

text_21:
	db "_____WALK INTO TH", 'E'|{line_1}
	db "_______WATERFALL",  '.'|{end}

//----------------------------------------

text_22:
	db "___SOME CREATURES AR",  'E'|{line_1}
	db "__WEAK AGAINST ARROWS", '.'|{end}

//----------------------------------------

text_23:
	db "____DIGDOGGERS HAT",      'E'|{line_1}
	db "_CERTAIN KINDS OF SOUND", '.'|{end}

//----------------------------------------

text_24:
	db "___I BET YOU'D LIK",   'E'|{line_1}
	db "__TO HAVE MORE BOMBS", '.'|{end}

//----------------------------------------

text_25:
	db "____IF YOU GO IN TH", 'E'|{line_1}
	db "____DIRECTION OF TH", 'E'|{line_2}
	db "_______ARROW MARK",   '.'|{end}

//----------------------------------------

text_26:
	db "____LEAVE YOUR LIF", 'E'|{line_1}
	db "_______OR MONEY",    '.'|{end}

//----------------------------------------

text_27:
	db "_THERE'S A SECRET IN TH", 'E'|{line_1}
	db "__POND WITHOUT A FAIRY",  '.'|{end}

//----------------------------------------

text_28:
	db "____AIM FOR THE EY", 'E'|{line_1}
	db "_______OF GOHMA",    '.'|{end}

//----------------------------------------

text_29:
	db "__SOUTH OF THE ARRO",   'W'|{line_1}
	db "__MARK HIDES A SECRET", '.'|{end}

//----------------------------------------

text_30:
	db "___SPECTACLE ROCK I",     'S'|{line_1}
	db "__AN ENTRANCE TO DEATH",  '.'|{end}

//----------------------------------------

text_31:
	db "__LOOK FOR THE ARROW", 'S'|{line_1}
	db "___IN DEATH MOUNTAIN", '.'|{end}

//----------------------------------------

text_32:
	db "_SEEK FOR THE LION KEY", '.'|{end}

//----------------------------------------

text_33:
	db "___THOSE WITHOUT TH",    'E'|{line_1}
	db "__TRIFORCE CANNOT PASS", '.'|{end}

//----------------------------------------

text_34:
	db "__GO TO THE NEXT ROOM", '.'|{end}

//----------------------------------------

text_35:
	db "____HAVE YOU FOUN", 'D'|{line_1}
	db "____THE RED TUNIC", '?'|{end}

//----------------------------------------

// padding
	fill $0C, $FF

//================================================================================

// freespace
bank 1; org $8CB0  // $04CC0

text_36:
    db "_____I'LL GIVE YO",       'U'|{line_1}
    db "_WHICHEVER ONE YOU WANT", '.'|{end}

//----------------------------------------

text_37:
    db "______DESTROY TH",    'E'|{line_1}
    db "___TOPMOST BOUNDARY", '.'|{end}
