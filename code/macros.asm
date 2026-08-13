;----------------------------------------
;	NES Macros for Asar
;----------------------------------------
macro org(address,bank)
    ; Most NES mappers work by making $8000-$BFFF hardcoded to bank 0-6 and switchable, then bank 7 is hardcoded to $C000-$FFFF.
    ; If your mapper is different, edit this function accordingly
	if <bank> == 0
	; org sets the position in the output file to write to (in norom, at least)
		org <address>-$8000+!headersize

	; base sets the position that all labels are relative to - this is necessary so labels will still start from $8000, instead of $0000 or somewhere
		base <address> 

	; For Metroid, bank 7 was changed to bank 15 when expanded, but we will make the macro identify both banks 7 and 15 for $C000-$FFFF
	elseif <bank> == 7 || <bank> == 15
		org <address>-$C000+$4000*<bank>+!headersize
		base <address>

		else
			org <address>-$8000+$4000*<bank>+!headersize
			base <address>
	endif
endmacro
;----------------------------------------
macro fillto(address,bank,byte)
	if <bank> == 0
		padbyte <byte> : pad <address>-$8000+!headersize
	elseif <bank> == 7 || <bank> == 15
		padbyte <byte> : pad <address>-$C000+$4000*<bank>+!headersize
	else
		padbyte <byte> : pad <address>-$8000+$4000*<bank>+!headersize	
	endif
endmacro
;----------------------------------------
