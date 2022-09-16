@echo off

REM 2013 = 12.0, 2015 = 14.0, 2017 = 15.0, 2019 = 16.0, 2022 = 17.0
SET VISUALSTUDIOVERSION=16.0
SET PLATFORM=Win32
SET CONFIGURATION=Release
SET MAXCPUCOUNT=4

REM :DOTNET_FIND
REM set DOTNET=%SystemRoot%\Microsoft.NET\Framework\v4.0.30319
REM if exist "%DOTNET%\MSBuild.exe" goto BUILD
REM set DOTNET=%SystemRoot%\Microsoft.NET\Framework\v3.5
REM if exist "%DOTNET%\MSBuild.exe" goto BUILD

REM :DOTNET_NOT_FOUND
REM echo .NET Framework not found. Build failed!
REM goto END

REM :BUILD
REM echo Using MSBuild found in %DOTNET%
REM set PATH=%DOTNET%;%PATH%


MSBuild "Kernel\BusmasterKernel.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%
MSBuild "BUSMASTER\BUSMASTER.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%

REM CAN PEAK USB.
REM MSBuild "BUSMASTER\CAN_PEAK_USB\CAN_PEAK_USB.vcxproj" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%

MSBuild "BUSMASTER\Language Dlls\Language Dlls.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%
MSBuild "BUSMASTER\LDFEditor\LDFEditor.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%
MSBuild "BUSMASTER\LDFViewer\LDFViewer.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=%CONFIGURATION% /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%

REM Asc Log
cd ..\Tools\flex 
"flex.exe" -i -L -o"..\..\Sources\BUSMASTER\Format Converter\AscLogConverter\Asc_Log_Lexer.c" "..\..\Sources\BUSMASTER\Format Converter\AscLogConverter\Asc_Log_Lexer.l"
cd ..\bison
"bison.exe" -d -l -o"..\..\Sources\BUSMASTER\Format Converter\AscLogConverter\Asc_Log_Parser.c" "..\..\Sources\BUSMASTER\Format Converter\AscLogConverter\Asc_Log_Parser.y"

REM Log Asc
cd ..\flex 
"flex.exe" -i -L -o"..\..\Sources\BUSMASTER\Format Converter\LogAscConverter\Log_Asc_Lexer.c" "..\..\Sources\BUSMASTER\Format Converter\LogAscConverter\Log_Asc_Lexer.l"
cd ..\bison
"bison.exe" -d -l -o"..\..\Sources\BUSMASTER\Format Converter\LogAscConverter\Log_Asc_Parser.c" "..\..\Sources\BUSMASTER\Format Converter\LogAscConverter\Log_Asc_Parser.y"

cd ..\..\Sources
MSBuild "BUSMASTER\Format Converter\FormatConverter.sln" /maxCpuCount:%MAXCPUCOUNT% /property:Configuration=Release /p:VisualStudioVersion=%VISUALSTUDIOVERSION% /p:Platform=%PLATFORM%
:END

