//****************************************************************
// 	Zelda 1 Redux - Text data
//****************************************************************

//****************************************
// 	Table file
//****************************************
table code/text/text.tbl

//****************************************
// 	Control codes
//****************************************
// ..xx xxxx    Letter Code
// .x.. ....    Start third line of text (after letter)
// x... ....    Start second line of text (after letter)
// Text ends when a byte has bits 6-7 set.
define line_1  $80  // line break
define line_2  $40  // line break
define end     $C0  // end


//***********************************************************
// 		Text pointers
//***********************************************************
bank 1;
org $8000  // 0x04010
    dw text_00,text_01,text_02,text_03
    dw text_04,text_05,text_06,text_07
    dw text_08,text_09,text_10,text_11
    dw text_12,text_13,text_14,text_15
    dw text_16,text_17,text_18,text_19
    dw text_20,text_21,text_22,text_23
    dw text_24,text_25,text_26,text_27
    dw text_28,text_29,text_30,text_31
    dw text_32,text_33,text_34,text_35
    dw text_36,text_37


//***********************************************************
// 		Dialogue
//***********************************************************

//----------------------------------------
text_00:
	db "___IT IS DANGEROUS T",	'O'|{line_1}
	db "__GO ALONE! TAKE THIS",	'.'|{end}
//----------------------------------------
text_01:
	db "__BECOME STRONGER AN",	'D'|{line_1}
	db "__YOU SHALL HAVE THIS",	'.'|{end}
//----------------------------------------
text_02:
	db "____CHOOSE YOUR PATH",	','|{line_1}
	db "_______YOUNG ONE",		'.'|{end}
//----------------------------------------
text_03:
	db "__WISDOM LIES BENEAT",	'H'|{line_1}
	db "__A TREE AT A DEAD-END",	'.'|{end}
//----------------------------------------
text_04:
	db "_____CARE TO PLAY ",	'A'|{line_1}
	db "___MONEY-MAKING GAME",	'?'|{end}
//----------------------------------------
text_05:
	db "__YOU OWE FOR THE DOO",	'R'|{line_1}
	db "__REPAIRS! NOW PAY UP",	'!'|{end}
//----------------------------------------
text_06:
	db "____SHOW THIS TO TH",	'E'|{line_1}
	db "_____ELDERLY WOMAN",	'.'|{end}
//----------------------------------------
text_07:
	db "__MEET THE OLD MAN A",	'T'|{line_1}
	db "_THE GRAVEYARD, DEARIE",	'.'|{end}
//----------------------------------------
text_08:
	db "__BUY MEDICINE AND B",	'E'|{line_1}
	db "__ON YOUR WAY, DEARIE",	'.'|{end}
//----------------------------------------
text_09:
	db "_I WON'T TALK FOR FREE",	'!'|{end}
//----------------------------------------
text_10:
	db "___THIS ISN'T ENOUG",	'H'|{line_1}
	db "___TO MAKE ME TALK..",	'.'|{end}
//----------------------------------------
text_11:
	db "___GO WAY UP AHEAD O", 	'N'|{line_1}
	db "__THE MOUNTAIN, DEARIE",	'.'|{end}
//----------------------------------------
text_12:
	db "_____GO NORTH, WEST",	','|{line_1}
	db "___SOUTH, AND WEST I",	'N'|{line_2}
	db "_____THE LOST WOODS",	'.'|{end}
//----------------------------------------
text_13:
	db "___YOU SURE ARE RICH",	'!'|{end}
//----------------------------------------
text_14:
	db "_BUY SOMETHIN' WILL YA",	'!'|{end}
//----------------------------------------
text_15:
	db "___THIS HERE'S A GOO",	'D'|{line_1}
	db "_VALUE AND WORTH BUYING",	'.'|{end}
//----------------------------------------
text_16:
	db "___YOU MUST CHOOSE..",	'.'|{line_1}
	db "___BUT CHOOSE WISELY",	'.'|{end}
//----------------------------------------
text_17:
	db "_____IT'S A SECRE",		'T'|{line_1}
	db "_____TO EVERYBODY",		'.'|{end}

//----------------------------------------
text_18:
	db "___GRUMBLE,GRUMBLE..",	'.'|{end}
//----------------------------------------
text_19:
	db "__YOU CAN'T USE ARROW",	'S'|{line_1}
	db "_____WITHOUT A BOW",	'.'|{end}
//----------------------------------------
text_20:
	db "__DODONGOS HATE SMOKE",	'.'|{end}
//----------------------------------------
text_21:
	db "_DID YOU GET THE SWOR",	'D'|{line_1}
	db "_FROM THE OLD MAN O",	'N'|{line_2}
	db "_TOP OF THE WATERFALL",	'?'|{end}
//----------------------------------------
text_22:
	db "_____WALK INTO TH",		'E'|{line_1}
	db "_______WATERFALL",		'.'|{end}
//----------------------------------------
text_23:
	db "___SOME CREATURES AR",	'E'|{line_1}
	db "__WEAK AGAINST SOUNDS",	'.'|{end}
//----------------------------------------
text_24:
	db "___DIGDOGGERS LOATH",	'E'|{line_1}
	db "_CERTAIN KINDS OF SOUND",	'.'|{end}
//----------------------------------------
text_25:
	db "_____DO YOU WISH T",	'O'|{line_1}
	db "____CARRY MORE BOMBS",	'?'|{end}
//----------------------------------------
text_26:
	db "__FOLLOW THE ARROW MAR", 	'K'|{line_1}
	db "___TO THE END, AND Y",	'E'|{line_2}
	db "______SHALL FIND..",	'.'|{end}
//----------------------------------------
text_27:
	db "_____PAY WITH MONEY",	','|{line_1}
	db "___OR PAY WITH BLOOD",	'.'|{end}
//----------------------------------------
text_28:
	db "___WISDOM LIES UNDE",	'R'|{line_1}
	db "___A FAIRYLESS POND",	'.'|{end}
//----------------------------------------
text_29:
	db "____AIM FOR THE EY",	'E'|{line_1}
	db "_______OF GOHMA",		'.'|{end}
//----------------------------------------
text_30:
	db "___SOUTH OF THE ARRO",	'W'|{line_1}
	db "____MARK HIDES GREA",	'T'|{line_2}
	db "_________WISDOM",		'.'|{end}
//----------------------------------------
text_31:
	db "___SPECTACLE ROCK I",	'S'|{line_1}
	db "___A GATEWAY TO DEATH",	'.'|{end}
//----------------------------------------
text_32:
	db "_SEEK THE SILVER ARROW",	'S'|{line_1}
	db "_WITHIN DEATH MOUNTAIN",	'.'|{end}
//===============================================================
// Pad to $45A2, or 0x045B2
	fillto $85A2, $FF
// Freespace
	org $9ED0  // 0x05EE0
//===============================================================
text_33:
	db "___SEEK THE LION KEY",	'.'|{end}
//----------------------------------------
text_34:
	db "___THOSE WITHOUT TH",	'E'|{line_1}
	db "_____TRIFORCE SHAL",	'L'|{line_2}
	db "________NOT PASS",		'.'|{end}
//----------------------------------------
text_35:
	db "______DESTROY TH",		'E'|{line_1}
	db "___TOPMOST BOUNDARY",	'.'|{end}
//----------------------------------------
text_36:
	db "__GO TO THE NEXT ROOM",	'.'|{end}
//----------------------------------------
text_37:
	db "____THE EYES OF TH",	'E'|{line_1}
	db "___SKULL HOLD SECRETS",	'.'|{end}
//----------------------------------------


