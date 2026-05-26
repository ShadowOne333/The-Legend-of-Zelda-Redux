# Makefile for compiling Metroid Fusion Redux
SHELL := /bin/bash
#-------------------------------------
.PHONY: all verify-name prepare verify-sha apply-patch
#-------------------------------------
# Config
FILE_BASE = Zelda1_Redux
OUT_FOLDER = out
PATCHES_FOLDER = patches
BASE_ROM = rom/Legend of Zelda, The (USA).nes
CLEAN_ROM = rom/Zelda1.nes
PATCHED_ROM = $(OUT_FOLDER)/$(FILE_BASE).nes
ASM_FILE = code/main.asm
ASAR = bin/asar
XKAS = bin/xkas
FLIPS = bin/flips
CHECKSUM = dab79c84934f9aa5db4e7dad390e5d0c12443fa2
#-------------------------------------
all: verify-name prepare verify-sha prepare apply-patch
#-------------------------------------
verify-name:
	@if [ -e "$(BASE_ROM)" ]; then \
		echo "ROM detected. Verifying name..."; \
	else \
		echo "ROM name is incorrect. Please, rename the ROM to 'Legend of Zelda, The (USA).nes' for the patching process to begin."; \
	fi
#-------------------------------------
prepare:
	@cp "$(BASE_ROM)" "$(CLEAN_ROM)"
	@mkdir -p "$(OUT_FOLDER)"
	@if [ -f "$(PATCHED_ROM)" ]; then rm "$(PATCHED_ROM)"; fi
#-------------------------------------
verify-sha:
	@if [ -f "$(CLEAN_ROM)" ]; then \
		echo "Base ROM detected with proper name. Checking SHA-1..."; \
	else \
		echo "Base ROM was not found. Place the 'Legend of Zelda, The (USA).nes' ROM inside the 'rom' folder."; \
	fi
	@sha1=$$(sha1sum "$(CLEAN_ROM)" | awk '{print $$1}'); \
	if [ "$$sha1" = "$(CHECKSUM)" ]; then \
		echo "Base ROM SHA-1 checksum verified. Patching MMC1 version with Redux..."; \
	else \
		echo "Base ROM checksum is incorrect. Use a Zelda 1 ROM with the proper SHA-1 checksum for patching."; \
	fi
#-------------------------------------
apply-patch:
	@cp "$(CLEAN_ROM)" "$(PATCHED_ROM)"
	@"$(XKAS)" -o "$(PATCHED_ROM)" "$(ASM_FILE)"
#	@"$(ASAR)" --no-title-check "$(ASM_FILE)" "$(PATCHED_ROM)"
	@"$(FLIPS)" --create --ips "$(CLEAN_ROM)" "$(PATCHED_ROM)" "$(PATCHES_FOLDER)/Zelda1_Redux.ips"
#-------------------------------------
clean:
	@rm -f "$(CLEAN_ROM)" "$(PATCHED_ROM)" "$(PATCHES_FOLDER)/Zelda1_Redux.ips"
	@echo "Cleaned patches and compiled ROMs."
#-------------------------------------
# Convenience target to only build patched ROM (skips checksum)
.PHONY: quick
quick: prepare apply-patch clean
	@echo "Quick build complete."
#-------------------------------------
