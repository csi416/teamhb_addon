@echo off

set actual_match=match001.txt

set current_dir=%~dp0
set src_dir_name=src
set src_dir_path=%current_dir%\%src_dir_name%
set dst_dir_name=elemzes
set dst_dir_path=%current_dir%\%dst_dir_name%

set ERRORLEVEL=
powershell "& '%current_dir%\analyze.ps1' -sourcePath '%src_dir_path%\%actual_match%'">"%dst_dir_path%\%actual_match%"
echo %ERRORLEVEL%

pause
