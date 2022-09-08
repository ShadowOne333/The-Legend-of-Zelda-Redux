# THE LEGEND OF ZELDA REDUX

-------------------

# **Index**

* [**The Legend of Zelda Redux Info**](#the-legend-of-zelda-redux)

* [**Changelog**](#changelog)

* [**Optional Patches**](#optional-patches)

* [**Patching and Usage Instructions**](#instructions)

* [**Credits**](#credits)

* [**Project Licence**](#license)


-------------------

## The Legend of Zelda Redux

Continuing over from the Zelda II Redux hack, The Legend of Zelda Redux aims to tackle some of the odd design and programming decisions from the original NES classic to revitalize and give new life to the beloved and cherished classic.

This hack tries to address a lot of points to make the game fit with the rest of the series (and Zelda 2 Redux) by doing some rebalancing and QoL changes, and also some visual flare into the game, without compromising the original game's design. Be sure to check the full Changelog inside the ReadMe file for the full list of changes made to this hack, and also don't forget to check the optional patches too!

Want to see the full development of the hack?

Follow it on the Romhacking.net thread:
https://www.romhacking.net/forum/index.php?topic=29403.0


-------------------

## Changelog

* Save manually with Up+A when in the Items Subscreen
* Reworked heart HUD to match Zelda 2 Redux
* Copy/Erase Save Feature: Now Zelda 1 has a newly implemented feature, similar to subsequent releases of the franchise, where you can Copy and/or Erase a save file to another Save Slot (Thanks to minucce!)
* The amount of hearts you last had if the game was saved manually is now saved. So when you load, you start with the same amount of life the user had when the save was done. If the number of hearts when the game was saved was 3, or lower than 3, the game will start Link with 3 hearts instead (like in subsequent Zeldas)
* Relocalization of the  game's script to better match the Japanese release, or have better hints altogether. Based on the Legends of Localization book/webpage (Except the two iconic "Take this" and "It's a secret" lines)
* Make the Blue tunic more vibrant
* Stop the HUD from disappearing when entering or leaving caves during overworld map
* Proper player sprite position when leaving overworld from caves
* Reduces random wait times when entering caves
* Fix Y-scroll timing glitch when changing screens
* Fix Q1-D1 door opening on its own if you enter-leave the dungeon
* Fix alignment of the sword beam in multiple directions
* Increment the initial bomb max. amount to 10 instead of 8
* Increment the bomb upgrades by 10 instead of the original 4. First upgrade should give you 20 bombs, second will be 30.
* Faster text printing
* Modify the Sword beam to only be active when at full health/heart, and stop shooting when the life gets to 3/4 of a heart
* Modify certain item names to better match subsequent official names in the franchise (Rupee, Fairy, Heart Container, etc.)
* Change the Red and Blue rings to Red and Blue tunics
* Introduction text rewrite
* Reimplementation of the warning screen from version PRG1 upon Game Over / Saving
* Slight modifications to the title screen to give the "ZELDA" title a red colour (modified fading palettes to match this change too)
* Possibly also add a breakable tile hint for overworld tiles
* Automap Plus, but modify it to have 1/4 heart decrements instead of 1/8 (this is needed in order to make space in sprite PPU for the next point (#3)
* Visible hint for breakable walls in Dungeons (already implemented, just need sprite space for the left walls)
* Remove the 1 Rupee flashing, and make it green if possible
* Press the Select button to toggle the item selected for the B Button (to avoid pausing the game to select an item everytime)
* Change the duplicate bosses in Level 4 and 7 (Gleeok and Aquamentus) to Lanmola and Patra respectively.
* Have 999 rupees as the maximum amount, instead of 255. The rupee amount also needs to be saved in SRAM for when the game loads, so it starts with whatever amount you had last time (thanks to Bogaa for this feature!)
* Add a proper arrow enemy-drop item and an arrow counter (shops give 30 arrows when purchased), with the max arrow limit being 30 for normal Arrows, and 60 once you get the silver Arrows (thanks to Bogaa for the Arrow drop/counter code, and stratoform for the Max arrows limits!)
* Slight graphic changes to make certain sprites match their official artwork (Link now has his yellow hat line, some shield slight change, etc.). This won't be a graphic update of the game, as I still want to retain the original game's overall art design and aesthetic, but with sprites that better depict their official artwork designs.
* Be able to kill the Pols Voice by playing the flute, and also with arrows to retain the original way of killing them (Thanks to stratoform for this!)
* Flip the heart rows in the File Select Screen (Thanks again stratoform!)
* New column definitions to make the overworld look more polished, adding corners, rounded edges and other slight stuff so the overworld doesn't look as blocky.
* Make recently bombed overworld walls have a new arched cave entrance tile, without the tile losing its properties from the previous tile $24 (new tiles are $54-$57): https://www.romhacking.net/forum/index.php?topic=29403.msg404505#msg404505
* Rework the Credits for the game to have full names show up for each developer (like in Zelda 2 Redux): https://www.romhacking.net/forum/index.php?topic=29403.msg403636#msg403636
* Diagonal Sword swing in Zelda 1, implemented by minucce. Inspired on initial work based on Displaced Gamer's [url=https://www.youtube.com/watch?v=FBk-QkzMeIk]"Zelda Hit Detection - Behind the Code"[/url] video


-------------------

## Optional patches:

* **Bluer Tunic.ips**		- Blue-er Tunic based on Asaki's hack
* **Tunic 2 Ring.ips**		- Change the Tunics back to Rings that use a new revamped sprite
* **Tunic 2 NES Ring.ips**		- Change Tunics to the Original Ring GFX from the NES release
* **Grey Automap.ips**		- Hide the unique Automap tiles and print out the grey tiles from the original
* **Disable Diagonal Sword.ips**	- Disable Diagonal Sword Swing for those that want the original Zelda 1 stab instead
* **Full Health at Start.ips**	- Fill the amount of hearts you have upon starting a save file, so you don't always start with 3 hearts only
* **Full Health After Death.ips**	- Fill the amount of hearts you have after a death or a Game Over
* **FDS Font.ips**			- Famicom Disk System's version Font graphics
* **Original Hidden Secrets.ips**	- Hide back all the overworld and dungeon secrets
* **Original Bomb Amounts.ips**	- Original bomb drops of 04 instead of 05 and upgrades amounts of 04 instead of 10
* **Link's Awakening GFX.ips**	- Link's Awakening graphics patch
* **Original HUD.ips**		- Original HUD to be the same as the original Zelda 1, with the map on the left and health on the right. If you want a Grey Automap with the Original HUD, use "Grey Automap (for Original HUD).ips"
* **Original NES GFX.ips**		- Original NES graphics
* **Original Overworld Columns.ips**	- Original (blocky) Overworld screen/column definitions
* **Remove Low Health Beep.ips**	- Remove the Low Health sound effect beeping
* **Remove Hyrule Fantasy Subtitle.ips**	- Remove the newly added "THE HYRULE FANTASY" subtitle from the title screen
* **Reworked Title Screen.ips**	- Reworked Title Screen to match more recent Zelda title screens
* **Remove Reworked TS Subtitle.ips**	- Reworked Title Screen without "THE HYRULE FANTASY" subtitle
* **Rearranged Bosses.ips**		- Unique bosses in each Dungeon/Level
* **Recoloured Dungeons.ips**	- Make each dungeon have its own unique colour palette similar to Modern Classic Edition
* **ZELDANameDoesntTrigger2ndQuest.ips**	- (Quite a mouthful, huh?) As the name implies, using this patch will make it so that if you start a save file with the name "ZELDA", it should start on a 1st Quest (like a normal file) instead of starting the file at 2nd Quest automatically.


-------------------

## Instructions

To play The Legend of Zelda Redux, the following is required:

* FCEUX 2.2.3 or above
* The Legend of Zelda NES ROM (Legend of Zelda, The (USA).nes, MD5: 337bd6f1a1163df31bf2633665589ab0)
* Lunar IPS
* Zelda1_Redux.ips patch

Grab the patches from inside the /patches/ folder from the GitHub page, or alternatively, download the .zip file from the Releases page (once a proper release is out) and apply the patch over your Legend of Zelda ROM with Lunar IPS.
If you want to apply any of the optional patches, you can use each Optional patch individually from inside the /patches/optional folder depending on your liking over your already patched The Legend of Zelda Redux ROM, or you can either compile them manually from the source code, although this is not recommended if you are not familiar with compilations or 6502 assembly.

-------------------

## Credits

* **Trax** - For his amazing disassembly of Zelda 1, which helped with a ton of stuff, and also for a lot of feedback and help in the development of this hack.
* **BogaaBogaa** - For his incredible help with the Arrows and 999 rupees code, flipping the Heart/Map positions in the HUD, reworked credits, MMC5 bank swapping and its animation and the extra dialogue for the cave warp screens.
* **Fiskbit** - For the MMC1 Animation, which uses a special NES 2.0 header.
* **DarkSamus993** - For his ASM help towards some hacks (like the Select button Item switch).
* **Stratoform** - For his help and code towards the Pols Voice flute code, fixing both the remaining stuff from porting the PRG1 Game Over screen's flashing and the cracked overworld walls collision, the flip hearts code and the max arrow limits.
* **snarfblam** - For the Automap hack, which was disassembled and modified to work with 1/4 hearts instead of 1/8 exclusively for this project
* **gzip** - For his Select button fix and the title screen slow waterfall animation.
* **minucce** - For his fixes for HUD Blink on cave enter/leave, scrolling timing, Link's sprite when leaving caves, Dungeon 1 Q1 door fix, random wait times when entering caves, magic beam alignment, the Diagonal Sword Swing code and the Copy/Erase save file system
* **kalita-kan** - For contributing with the "ZELDA name" and "Full Hearts after death" optional patches.
* **lexluthermeister** - For his help on creating the Optional patch for the new bosses.
* **BlazeHeatnix** - For some script revisions and suggestions.
* All other users that gave their feedback on possible ways to improve the game over at the [RomHacking.net](https://www.romhacking.net/forum/index.php?topic=29403.0) thread, and those that gave insightful ideas and mockups!

-------------------


## License

The Legend of Zelda Redux is a project licensed under the terms of the GPLv3, which means that you are given legal permission to copy, distribute and/or modify this project, as long as:

1) The source for the available modified project is shared and also available to the public without exception.
2) The modified project subjects itself different naming convention, to differentiate it from the main and licensed The Legend of Zelda Redux project.

You can find a copy of the license in the LICENSE file.
