//********************************************************************************
// Main assembly file.
// All of the assembly files get linked together and compiled here.
//********************************************************************************
//****************************************
// Rom info
//****************************************
arch nes.cpu		// set processor architecture (NES)
banksize $4000		// set the size of each bank
header			// rom has a header

//****************************************
// Redux changes
//****************************************
incsrc code/misc.asm			// Main ASM code for Redux

//****************************************
// Gameplay changes
//****************************************
incsrc code/bombs.asm			// Increase initial max bombs and upgrades to 10
incsrc code/automap.asm			// Disassembly of the Automap Plus hack by snarfblam

//****************************************
// Text changes
//****************************************
incsrc code/text.asm			// Relocalization of the game's script
incsrc code/story.asm			// Rewrite of the game's story and intro texts
incsrc code/credits.asm			// Rewrite of the game's credits sequences

//****************************************
// Visual changes
//****************************************
incsrc code/graphics.asm		// Sprite/graphic changes
incsrc code/title_screen.asm		// Title screen visual changes
incsrc code/tunic_colors.asm		// Make blue tunic more vivid

//****************************************
// Optional patches
//****************************************

//incsrc code/optional/optional.asm	// Optional patches for Zelda Redux
