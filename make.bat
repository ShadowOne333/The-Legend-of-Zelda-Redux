@ECHO OFF

SET "out_folder=%~dp0\output"
SET "patches_folder=%~dp0\patches"
SET "clean_rom=rom\Legend of Zelda, The (USA).nes"
SET "patched_rom=%out_folder%\Zelda1_Redux.nes"
SET "asm_file=code\main.asm"

IF NOT EXIST "%out_folder%" MKDIR "%out_folder%"
IF EXIST "%patched_rom%" DEL "%patched_rom%"

COPY "%clean_rom%" "%patched_rom%"

bin\xkas.exe -o "%patched_rom%" "%asm_file%"
bin\flips.exe --create --ips "%clean_rom%" "%patched_rom%" "%patches_folder%\Zelda1_Redux.ips"

PAUSE
