#!/bin/bash

export  out_folder=out
export  clean_rom=rom/Legend\ of\ Zelda\,\ The\ \(USA\).nes
export  patched_rom=$out_folder/Zelda1_Redux.nes
export  asm_file=code/main.asm

if [ ! -d "$out_folder" ]; then
	mkdir "$out_folder"
fi

if [ -f "$patched_rom" ]; then
	rm "$patched_rom"
fi

cp "$clean_rom" "$patched_rom"

bin/xkas -o "$patched_rom" "$asm_file"
bin/flips --create --ips "$clean_rom" "$patched_rom" "$out_folder/Zelda1_Redux.ips"

sleep 2
exit
