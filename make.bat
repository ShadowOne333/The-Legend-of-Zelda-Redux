@echo off
set dopause=0
set file_base=Zelda1_Redux
SET "out_folder=%~dp0output"
SET "patches_folder=%~dp0\patches"
SET "clean_rom=rom\Legend of Zelda, The (USA).nes"
SET "patched_rom=%out_folder%\%file_base%.nes"
SET "asm_file=code\main.asm"

IF NOT EXIST "%clean_rom%" set errormessage=Please place The file "%clean_rom%" was not found.&goto error

IF NOT EXIST "%out_folder%" MKDIR "%out_folder%"
IF EXIST "%patched_rom%" DEL "%patched_rom%"

COPY "%clean_rom%" "%patched_rom%" >NUL
if %errorlevel% NEQ 0 set errormessage=Could not copy file.&goto error

bin\xkas.exe -o "%patched_rom%" "%asm_file%"
if %errorlevel% NEQ 0 set errormessage=Could not patch rom.&goto error
bin\flips.exe --create --ips "%clean_rom%" "%patched_rom%" "%patches_folder%\%file_base%.ips">NUL
if %errorlevel% NEQ 0 set errormessage=Could not create ips.&goto error

goto theend

:error
echo.
echo.ERROR: %errormessage%
echo.
pause
exit

:theend
echo Done.
if %dopause% NEQ 0 pause
