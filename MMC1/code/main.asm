//****************************************************************
//	Main assembly file for Zelda 1 Redux
// All of the assembly files get linked together and compiled here.
//****************************************************************

// !!!WARNING!!!
// This project depends on the compilation of the files to be in the precise order they are set in this file. DO NOT modify the order in which the ASM files are, or else the game might break!

//****************************************
//	Rom info
//****************************************
arch nes.cpu		// set processor architecture (NES)
banksize $4000		// set the size of each bank
header			// rom has a header

//****************************************
//	iNES Header
//****************************************
//	db $4E,$45,$53,$1A	// Header (NES $1A)
//	db $08			// 8 x 16k PRG banks
//	db $00			// 0 x 8k CHR banks
//	db %00010010		// ROM Settings
	//  |||||||^--- Mirroring: Vertical
	//  ||||||^--- SRAM: Yes
	//  |||||^--- 512k Trainer: Not used
	//  ||||^--- 4 Screen VRAM: Not used
	//  ^^^^--- Mapper: 1
//	db %00000000		// RomType: NES
//	db $00,$00,$00,$00	// iNES Tail
//	db $00,$00,$00,$00


//****************************************
// 	MMC1 Animation code
//****************************************

// Animate tiles using the original CHR-RAM mapper for Zelda 1
incsrc code/animation/animate.asm	// Animated tiles for Zelda 1 MMC1


//****************************************
//	Visual changes
//****************************************
incsrc code/gfx/graphics.asm		// Sprite/graphic changes
incsrc code/gfx/palettes.asm		// Several palette changes
incsrc code/gfx/title_screen.asm	// Title screen visual changes
incsrc code/menus/caution_screen.asm	// Implement the CAUTION screen from the PRG1 version
incsrc code/menus/file_select.asm	// Modifications to the File Select menus
incsrc code/menus/hud_and_subscreen.asm	// Changes to both the HUD and the Subscreen


//****************************************
//	Bugfixes
//****************************************
incsrc code/bugfixes/overworld_hud_blink.asm	// Stops HUD from disappearing when entering or leaving caves during overworld map
incsrc code/bugfixes/overworld_scroll_timing.asm	// Fix for Y-scroll timing glitch
incsrc code/bugfixes/overworld_leave_cave.asm	// Fix wrong player sprite position on entering overworld from caves


//****************************************
//	Text changes
//****************************************
incsrc code/text/script.asm		// Relocalization of the game's script
incsrc code/text/story.asm		// Rewrite of the game's story and intro texts
incsrc code/text/credits.asm		// Rewrite of the game's credits sequences
incsrc code/text/text_speed.asm		// Modify text parsing speed


//****************************************
//	Gameplay changes
//****************************************
//incsrc code/file_tweaks.asm		// File Select changes
incsrc code/gameplay/arrows.asm		// Arrow counter code by BogaaBogaa
incsrc code/gameplay/automap.asm	// Disassembly of the Automap Plus hack by snarfblam
incsrc code/gameplay/bombs.asm		// Increase initial max bombs and upgrades to 10
incsrc code/gameplay/item_toggle.asm	// Pressing Select toggles the selected B Button item from the inventory
incsrc code/gameplay/manual_save.asm	// Save manually by pressing Pause and then Up+A (Button combo can be modified)
incsrc code/gameplay/misc.asm		// Miscellaneous hacks
incsrc code/gameplay/pols_voice.asm	// Kill Pols Voices by using Flute or Arrows
incsrc code/gameplay/rupee.asm		// 999 Rupee counter code by BogaaBogaa
incsrc code/gameplay/overworld_screens.asm	// Changes some columns for certain screens in the Overworld to not look as blocky
incsrc code/gameplay/visible_secrets.asm	// Discernible secrets for bombable (cracked) walls in both Overworld and Dungeons, and burnable trees in the Overworld
incsrc code/gameplay/move_maps.asm	// Change Hearts and Map positions in HUD (INCLUDE AFTER HUD, ARROWS, RUPEE AND AUTOMAP CODE!)


//****************************************
//	Optional patches
// Uncomment the desired Optional patches
//****************************************

// Include optional patches
// Uncomment desired patches inside "optional.asm" for them to compile
incsrc code/optional.asm


