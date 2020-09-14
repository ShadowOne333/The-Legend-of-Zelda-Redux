#! /bin/bash

export	file_base=Zelda1_Redux
export  out_folder=out
export	patches_folder=patches
export  clean_rom=rom/Zelda1.nes
export  patched_rom=$out_folder/$file_base.nes
export  asm_file=code/main.asm

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

cd rom/ && cp Legend\ of\ Zelda\,\ The\ \(USA\).nes Zelda1.nes && cd ..
test ! -d "$out_folder" && mkdir "$out_folder"
test -f "$patched_rom" && rm "$patched_rom"

if [ -f "$clean_rom" ]; then
	echo "Base ROM detected. Patching..." 
else
	export error="Base ROM was not found. Place the 'Legend of Zelda, The (USA).nes' ROM inside the 'rom' folder." && jumpto ERROR
fi

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
