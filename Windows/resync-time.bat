@ECHO off
REM Needs admin rights
sc.exe start W32Time
w32tm.exe /resync /force