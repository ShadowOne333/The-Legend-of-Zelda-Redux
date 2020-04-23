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
incsrc code/redux.asm		// Main ASM code for Redux

//****************************************
// Gameplay changes
//****************************************
incsrc code/bombs.asm		// Increase initial max bombs and upgrades to 10
incsrc code/automap.asm		// Disassembly of the Automap Plus hack by snarfblam
incsrc code/arrows.asm		// Arrow counter code by BogaaBogaa
incsrc code/rupee.asm		// Rupee 999 counter code by BogaaBogaa
incsrc code/move_maps.asm	// Change Hearts and Map positions in HUD

//****************************************
// Text changes
//****************************************
incsrc code/text.asm		// Relocalization of the game's script
incsrc code/story.asm		// Rewrite of the game's story and intro texts
incsrc code/credits.asm		// Rewrite of the game's credits sequences

//****************************************
// Visual changes
//****************************************
incsrc code/graphics.asm	// Sprite/graphic changes
incsrc code/title_screen.asm	// Title screen visual changes
incsrc code/tunic_colors.asm	// Make blue tunic more vivid

//****************************************
// Optional patches
// Uncomment the desired Optional patches
//****************************************

// Original NES Graphics
// NOTE: This one can't be combined with the LA DX Graphics
//incsrc code/optional/OriginalGFX.asm

// Link's Awakening DX Graphics
//incsrc code/optional/LinksAwakeningGFX.asm

// Recoloured Dungeons
//incsrc code/optional/RecolouredDungeons.asm

// Rearranged Bosses for Both Quests
//incsrc code/optional/RearrangedBosses.asm

// Increase bomb upgrades from 4 to 5
//incsrc code/optional/BombUpgrades5.asm

// Optional?
// One of the MMC conversions, either MMC3 or MMC5, or Optimum
// This will make it possible to have animations in the game, and make a lot of free space for custom graphics and diagonal swing graphics (maybe)
