//SRAM Map SaveFormat:
//File1 $7f60
//File2 $7f70
//File3 $7f80
//The Full map is 16 byte wide. Every byte represents a Column.
//
//Byte Column Encoding
//Bottom Half 	Top Half
//	1 1 1 1   	1 1 1 1 Show Full Column	$ff
//	1 0 0 0		0 0 0 0 First Tile Bottom  	$80
//	0 1 0 0		0 0 0 0 Second Tile Bottom 	$40 and $10 is the last one.
//  This map File will be copied to SRAM $7f50 and drawn fully at lunch. After there will be checks for current screen.
//
//$7f00 Current Column map
//$7f01 Current Row map
//$7f02 Flag to Draw Full Map
//$7F03 Ypos Link Marker on map. Used while flashing and blanked out.
//
//$6CB4 Flag Used when start Scrolling. LinkMarker Update?
//The HudMap does consist of 32 tiles. 4 Rows and 8 Columns.
//$6CB6 00=Column1, 01=Column2, 02=Column3, 03=Column4, 04=Column5, 05=Column6, 06=Column7, 07=Column5 
//$6CB7	00=MapRow1, 01=MapRow2, 02=MapRow3, 03=MapRow4 


bank 1;		////PRG 4000

org $a450

CopyToSRAM:
	LDY #$00       	//Copy code block to SRAM. Run on startup          
CopyToSRAMLoop:
	LDA CodeBlock,y              
	STA $7F90,y              
	INY                      
	CPY #$6f    	//Size of block    Max size.. This can be used to copy other code as well. 
					//Probably would be good to define SRAM locations/Routines to make code more readable.
					//Define $7f90=BankSplice //Check if bank 5 and go to SRAM or Bank 5 location accordingly
	BNE CopyToSRAMLoop                

//-------------------------MMC5-Feature--------------------------------------
//MMC5 For Addictional SRAM. Only used with MMC5 so 
//I copy the same code to not break anything when used on a different mapper.
	lda #$01		//Switch SRAM Page
	sta $5113
	
CopyToSRAM2:
	LDY #$00       	//Copy code block to SRAM. Run on startup          
CopyToSRAMLoop2:
	LDA CodeBlock,y              
	STA $7F90,y              
	INY                      
	CPY #$6f
	BNE CopyToSRAMLoop2      
	
	lda #$00		//Set batterybacked default again
	sta $5113
//-------------------------------------------------------------------------
	JSR $8D00   	//This will fix the hijack and go to RTI eventually I guess.
	
CodeBlock:	
	PHA           		//blip?           
	LDA $8000                
	CMP #$20       	//Check bank 5          
	BNE GoSRAM                
	PLA                      
	JMP $BDF0     		//If bank 5           
GoSRAM:	
	PLA                      
	JMP $77E7          //Else SRAM routine

MapFlags:
	lda $12
	cmp #$04			//Check if it will turne to 5 soon. Overworld check
	bne EndMapFlags
	inc $7f02			//SetFlag to draw map
	lda #$00			//Used for waterfall.asm. It needs a buffer before it can run in play mode since automap is bussy doing things
	sta $704
EndMapFlags:	
	jsr $eba1			//HijackFix
	rts
	
	
	//ascii for signing people in the debugger wher to put code :P
	//Goes into SRAM. A good place to organize bank transitions system! This is just a note to see in the debugger.
	jsr $cafe			//I just like coffee
	db "goes_into_sram._a_good_place_to_transit_to_different_banks"

	
	fillbyte $ea 
	fillto $64cf


org $a5a1		//goes to SRAM $6d31. Run when MasterKey (Lion) is optained
	lda #$64
	
org $a738
	cmp #$c0	//goes to SRAM $6ec8
	
org $a741
	jmp HealthRefill
	nop

bank 2;			////PRG 8000
org $a2c7
	jsr DeleteMapFromSave


org $a5fe
	jsr LoadMap

org $a764		//HijackFix?
org $a77a
	jsr $b000

org $abb5
	jmp $b026


// Free Space for new Code ----------------------------------------------
org $b000				//Will bring the save map to the right location in SRAM. When you register/save  
	JSR ChoosMap                
LoadMapLoop1:	
	LDA $7F50,x              
	STA $7F60,y              
	DEY                      
	DEX                      
	BPL LoadMapLoop1                
	JMP $9D2A      		//FixHijack?             

LoadMap:
	jsr ChoosMap
LoadMapLoop2:	
	LDA $7F60,y   		//Will bring the save2 map to the right location in SRAM. When you load game        
	STA $7F50,x              
	DEY                      
	DEX                      
	BPL LoadMapLoop2               
	JMP $E625  			//FixHijack?              
	
DeleteMapFromSave:		//Delete map from save file
	jsr Delete
	jmp $a764			//FixHijack?
	jsr Delete			
	jmp $af5a			//FixHijack?

Delete:	
	LDX #$0F                 
	LDA #$00                 
LoopDelete:
	STA $7F50,x             
	DEX                      
	BPL LoopDelete               
	RTS                      

ChoosMap:
	LDY #$0F        	//Choose Save Map 1        
	LDX $16       		//Load Current Save Slot          
	BEQ EndLoad               
	LDY #$1F            //Choose Save Map 2
	DEX                      
	BEQ EndLoad             
	LDY #$2F            //Choose Save Map 3 
EndLoad:	
	LDX #$0F      		//LoadMapSize          
	RTS                      


bank 5;				////PRG 14000
org $85a0 				// Free Space for new Code ----------------------------------------------
VisitedMapFlags:		//!!
	LDA $EB         	//Get Map Xpos and Ypos         
	AND #$0F           //Take Xpos and move to X register
	TAX                      
	LSR                  
	STA $7F00   
	PHA                      
	
	LDA $EB    		//Take Ypos shift to lower nibble (halfbyte) move to Y register.             
	LSR                   
	LSR                  
	LSR                  
	LSR                  
	TAY                      
	
	LSR            		//Devide since marker moves half a tile. Push Ypos/Row Map   
	STA $7F01   
	PHA                      
	
	LDA #$01            //Check for top Row?
	CPY #$00                 
	BEQ StoreVisitFlag              

CheckNext:	
	ASL                   
	DEY             	//DecRow         
	BNE CheckNext              

StoreVisitFlag:	
	ORA $7F50,x            
	STA $7F50,x              
	PLA       			//Pull YposMap/Row              
	TAY                      
	PLA         		//Pull XposMap/Column          
	TAX                      
	JSR GetDiscoverData                
	JMP $A9F4                

//-------------------------------------------
SetCaveFlag:
	lda $5b
	cmp #$0b
	bne EndSetCaveFlag
	dec $7f02		//SetFlag to clear map
EndSetCaveFlag:	
	sta $12
	rts
org $8ba1
	jsr SetCaveFlag
	nop
//--------------------------------------------

org $a8be
	jsr VisitedMapFlags		//!!

org $a8de						//May be the initial thing should not be used?
	jsr FullMapDrawFlag		//Not used to draw at initial screen lvl 0 //Orginal	lda #$1a	sta $00		//hijackFix
	nop


org $af20
CheckCurrentLevel:	
	LDA $10      			//Load Current Level		
	BEQ EndLvLCheck    	//Branch if Overworld            
	LDA $14 				//Load PPU Index                 
	CMP #$0E            	//Check?     
	BNE EndLvLCheck                
	LDA #$7E                 
	STA $14    			//Update PPU Index              
EndLvLCheck:	
	INC $13             	//Increas Routine Index   
	RTS                      

org $b01a
	jmp CheckCurrentLevel
	
org $b1ea					//Part of Add health routine
	LDA #$10        		//Load heart fill sound         
	STA $0604	        	//Store Puls Sound Trigger        
	LDA $0670           	//Load Partial Health     
	CMP #$D7  				//Check for sub health/heart indicator               
	BCS HeartFill                
	CLC                      
	ADC #$18     			//AddHealth            
	STA $0670                
	RTS                      
HeartFill:

org $bdf0					//Posstion of Links Marker on Map
LinkMarker:	
	PHA                      
	LDA $10       			//Load Current Level           
	BNE EndOverworldSet	//Branch Not overworld     
	LDA $0254         	  	//Ypos of Link marker on Map    
	CMP #$FF                 
	BEQ WhenBlankedOut          
	STA $7F03				//Store Current Ypos on Map here while blanked out.              

WhenBlankedOut:	
	LDA $15       			//Load Frame Counter           
	LSR                		//Get 5 Nibble to branch every 10 frames?
	LSR                    
	LSR                    
	LSR                    
	LSR                    
	BCC BlankMarker  	         
	LDA $7F03           	//Load Ypos on Map after blank is over    
	STA $0254 				//Links Marker Ypos on Map               
	BNE EndOverworldSet                
BlankMarker:	
	LDA #$FF            	// Will make the marker blink. Here the possition is outside of screen.     
	STA $0254 				//Links Marker Ypos on Map                
EndOverworldSet:	
	PLA                      
	JMP $77E7                

	
GetDiscoverData:	
	STX $6CB6       		//CurrentColumn xPos         
	STY $6CB7           	//CurrentRow. Takes value in $EB LSR 5 times  
	TXA                      
	ASL                    
	TAX                      
	LDA $7F50,x     		//Get Map Column         
	JSR ColumnData                
	STA $6CB5                               
	LDY $6CB7                
	LDA $7F51,x              
	JSR ColumnData                               
	LDA #$01 				//Flag for?                
	STA $6CB4                
	JSR DrawPartialMap       
	RTS                               

ColumnData:	
	CPY #$00                 
	BEQ EndColumn                
GetColumnData:	
	LSR                  
	LSR                   
	DEY                      
	BNE GetColumnData               
EndColumn:	
	AND #$03                 
	RTS                               

org $be4f
DrawPartialMap: //New for MMC5	
	
	lda #$00
	ldx $7f00				//load xPos and Ypos of map
	ldy $7f01
	beq LoadTile			//branch if first row
	
	LoopPointerCalc:
	clc
	adc #$08
	dey
	cpy #$00
	bne LoopPointerCalc
	

LoadTile:	
	clc
	adc $7f00				//Add row offset
	tax
	lda MapNameTaRW1,x
	sta $7f08				//Tile
	
	lda #$01
	sta $7f07			//Leangth
	lda #$20				
	sta $7f06			//Pointer Highbyte
	
	lda $7f01
	asl
	asl
	asl
	asl
	asl
	clc
	adc #$76
	adc $7f00				//Offset Row
	sta $7f05			//Pointer Lowbyte
	lda #$ff
	sta $7f09
	rts

MapNameTaRW1:
	db $30,$31,$32,$33,$34,$35,$36,$37		//DestPPU $2076
MapNameTaRW2:
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F		//DestPPU $2096
MapNameTaRW3:
	db $40,$41,$42,$43,$44,$45,$46,$47		//DestPPU $20b6
MapNameTaRW4:
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF //DestPPU $20d6 


FullMapDrawFlag:
	lda $10		//Check Current Level
	bne	Underworld
	
	lda #$01	//Flag to draw map while the screen opens
	sta $7f02
Underworld:
	lda #$1a	//HijackFix Initial screen hijack
	sta $00

	rts


	
HealthRefill:	
	LDA $0670 	//Load Partial Health               
	LSR                    
	LSR                    
	LSR                    
	LSR                    
	LSR                    
	LSR                    
	CLC                      
	ADC #$50                 
	JMP $6ED7                


bank 6;			////PRG 18000

org $8089
//	jmp EndOverworldMapLoad	////This routine was orginaly in the vector bank to swap to a other bank and back.
 	
org $8014
	dw MapNameTableData				//Load Tilmap + data of overwold to SRAM. The next pointer will be dungeon related
 
org $9300
MapNameTableData:			
//	db $3F,$00,$20,$0F,$30,$00,$12,$0F,$16,$27,$30,$0F		//Overworld data
//	db $1A,$37,$12,$0F,$17,$37,$12,$0F,$29,$27,$17,$0F
//	db $02,$22,$30,$0F,$16,$27,$30,$0F,$0C,$1C,$2C,$FF
//	db $01,$04,$05,$06,$8D,$57,$49,$99,$69,$00,$A0,$77
//	db $2A,$7F,$06,$00,$1D,$23,$49,$79,$FF,$FF,$FF,$FF
//	db $FF,$FF,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
//	db $FF,$FF,$FF,$FF,$FF,$FF,$FF
												//This are the metadata to go into the PPU nametable. Map
												//This will arrange tilemaping of the map in the HUD. 
												//MoveMap will use same offset with different PPU pointers in table.
org $934f		//This org is not needed but the above data might be edited by other tools..
	db $20,$62,$08
	db $24,$24,$24,$24,$24,$24,$24,$24		//DestPPU $2076
	db $20,$82,$08
	db $24,$24,$24,$24,$24,$24,$24,$24		//DestPPU $2096
	db $20,$A2,$08
	db $24,$24,$24,$24,$24,$24,$24,$24		//DestPPU $20b6
	db $20,$C2,$08
	db $24,$24,$24,$24,$24,$24,$24,$24,$FF 	//DestPPU $20d6

org $9d70
UpdatePartialMapTile:	
	JSR $A080			//Check stuff and goes into PPU routines?
	LDA $10				//Check for overworld? 
	BNE NotOverworld
	
	lda $7f02			//FlagFullMapUpdate
	beq UpdateTile
	bmi EraseMap
	jsr DrawFullMap
UpdateTile:	
	LDX $6CB4			//Checks if Scrolling/Transition? 00=Normal 01=?
	BEQ EndCheckStuff

	LDA $2002    		// read PPU status to reset the high/low latch
	LDA $7f06
	STA $2006    		// write the high byte 
	LDA $7f05
	STA $2006    		// write the low byte 

	LDA $7f08     		//load Tile to update
	STA $2007          	//write to PPU
	
NotOverworld:	
	LDA #$00
	STA $6CB4
EndCheckStuff:
	RTS

EraseMap:
	txa
	pha
	tya
	pha
	
	jsr EraseMapNametable
	
	pla				//backup from stuck
	tay
	pla
	tax
	
	jmp NotOverworld

//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
//Byte Column Encoding
//Bottom Half 	Top Half
//	1 1 1 1   	1 1 1 1 Show Full Column	$ff
//	1 0 0 0		0 0 0 0 First Tile Bottom  	$80
//	0 1 0 0		0 0 0 0 Second Tile Bottom 	$40 and $10 is the last one.
//  This map File will be copied to SRAM $7f50 and drawn fully at lunch.
// $00 PPU Offset
// $01 Row

DrawFullMap:	
	lda $00		//Backup to stuck
	pha
	txa
	pha
	tya
	pha
	
	ldx $7f0a		//CopyMapNameTa
	ldy $7f04		//Column counter
	
	lda #$76		//PPU Map Start. This value should be copied form pointer at bank 6 org $9350!
	clc
	adc $7f0a		//Offset with x data table and PPU pointer
	
	sta $00		//Holds LowByte PPU
	
NextColumnSave:		
	lda #$03		//Check 4 rows
	sta $01

MapColumnLoop:
	clc
	lda $7f50,y
BitCheckLoop:
	lsr				//Every two bit is a tile to check
	bcs StoreTile
	lsr
	bcs StoreTile
	
	pha				//KeepBitCheckValue
	
//	LDA $2002		//StoreEmptyTile This is not needed but helpful for debugging	       
//	LDA #$20               
//	STA $2006		//PpuAddr_2006         
//	LDA $00 	             
//	STA $2006		//PpuAddr_2006
//	lda #$24
//	sta $2007
SetNextBit:	
	lda $00		//RowSwitch
	clc	
	adc #$20
	sta $00
	
	txa				//Next Row CopyMapNameTa
	clc
	adc #$08
	tax
	
	pla				//KeepBitCheckValue
	
	dec $01		//Next Row
	bmi NextColumn
	jmp BitCheckLoop

StoreTile:
	pha				//KeepBitCheckValue
	
	LDA $2002	       
	LDA #$20               
	STA $2006		//PpuAddr_2006         
	LDA $00 	             
	STA $2006		//PpuAddr_2006
	lda CopyMapNameTa,x
	sta $2007

	jmp SetNextBit
	
NextColumn:		
	txa				//Set CopyMapNameTa x to first row next tile
	sec
	sbc #$1f
	tax
	
	lda $00		//Update PPU Pointer to next Row
	sec
	sbc #$7f
	sta $00
	
	iny
	cpy #$10		//Check if finished
	bne StoreColumnOffset

	lda #$00		//SetFlagDrawn	
	sta $7f02	
	ldy #$00
StoreColumnOffset:
	sty $7f04		//Current Column
	tya
	lsr
	sta $7f0a		//we like to skip every second column to be drawn. Since one tile is two columns of discovery data.


	
	pla				//backup from stuck
	tay
	pla
	tax
	pla
	sta $00

	RTS

CopyMapNameTa:
	db $30,$31,$32,$33,$34,$35,$36,$37		//DestPPU $2076
	db $38,$39,$3A,$3B,$3C,$3D,$3E,$3F		//DestPPU $2096
	db $40,$41,$42,$43,$44,$45,$46,$47		//DestPPU $20b6
	db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$FF //DestPPU $20d6 	
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------
EraseMapNametable:
	pha				//Backup A Not sure if needed.. X Y I did check
	
	
	ldy #$76	
ClearMap:	
	LDA $2002	       
	LDA #$20               
	STA $2006		//PpuAddr_2006         	             
	STY $2006		//PpuAddr_2006
	ldx #$08		//A Row
	lda #$24		//EmptyTiles
LoopClear:	
	sta $2007
	dex
	bne LoopClear
	
	tya				//Offset PPU pointer till done
	clc
	adc #$20
	cmp #$f6
	beq	EndClearMap
	tay
	jmp ClearMap
		
EndClearMap:	
	lda #$00
	sta $7f02
	
	pla
	rts


org $a00e				//This is just a small part of the pointer table here. Would be cool to have the full table and content.
	dw HudArrangment	//PRG $1bef0
org $a07e
	dw $a2d3			//Bug? Patch overwrites?

org $bef0				//Hud Arrangement Hearts,Rupee.. (This is covered in what patch?)
	HudArrangment:
org $bf00				
	db $CC,$AA,$A6	//Part of the map nametable attribute. To make wood green

bank 7;				////PRG 1c000
base $C000				//Set offset of last bank

org $e4c1
	jsr UpdatePartialMapTile			//? Will make screen black if nop

org $e901
	jsr CopyToSRAM

org $ebf2			//set Flags to draw map or clear it.
	jsr $7fa0

	
org $f322
	jsr $7f90


//This is needed for Orginal MMC1 
bank 2;
org $8a7f
incbin code/gameplay/automap_tiles.bin

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Depents on rupee.asm	 to write a routine where the orginal Hud preset table was. 
//org $A507	// CPU $6C97, 0x06517
//Also expansion and table at bank 5 org $AC70

//move_maps.asm	will have needed changes for it to work.

//Further depends so the world will not come with messed up columns with wrong pattern arrangment/fuctioning caves..
//visible_secrets.asm
//overworld_screens.asm does debend ond visible secrets



