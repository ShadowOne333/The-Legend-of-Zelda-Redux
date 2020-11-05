#! /bin/bash

export	file_base=Zelda1_Redux
export  out_folder=out
export	patches_folder=patches
export  clean_rom=rom/Zelda1.nes
export  patched_rom=$out_folder/$file_base.nes
export  asm_file=code/main.asm
export	checksum=dab79c84934f9aa5db4e7dad390e5d0c12443fa2

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

start=${1:-"start"}
jumpto $start

start:

if [ -e rom/Legend\ of\ Zelda\,\ The\ \(USA\).nes ]; then
	echo "ROM detected. Verifying name..."; else
	export error="ROM name is incorrect. Please, rename the ROM to 'Legend of Zelda, The (USA).nes' for the patching process to begin." && jumpto ERROR; fi

cd rom/ && cp Legend\ of\ Zelda\,\ The\ \(USA\).nes Zelda1.nes && cd ..
test ! -d "$out_folder" && mkdir "$out_folder"
test -f "$patched_rom" && rm "$patched_rom"

if [ -f "$clean_rom" ]; then
	echo "Base ROM detected with proper name. Checking SHA-1..."; else
	export error="Base ROM was not found. Place the 'Legend of Zelda, The (USA).nes' ROM inside the 'rom' folder." && jumpto ERROR; fi

export	sha1=$(sha1sum "$clean_rom" | awk '{ print $1 }')

if [ "$sha1" == "$checksum" ]; then
	echo "Base ROM SHA-1 checksum verified. Patching..."; else
	export error="Base ROM checksum is incorrect. Use a Zelda 1 ROM with the proper SHA-1 checksum for patching." && jumpto ERROR; fi


cp "$clean_rom" "$patched_rom"
bin/xkas -o "$patched_rom" "$asm_file"
bin/flips --create --ips "$clean_rom" "$patched_rom" "$patches_folder/Zelda1_Redux.ips"

jumpto END

ERROR:
echo "ERROR: $error"

END:
rm $clean_rom
sleep 1
exit
