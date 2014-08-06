; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply 
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there. 

;--------------------------------

!define APP "CheckNpgsqlSetupStatus"
!define VER "0.1"

!searchreplace APV ${VER} "." "_"

; The name of the installer
Name "${APP} ${VER}"

; The file to write
OutFile "Setup_${APP}_${APV}.exe"

; The default installation directory
InstallDir "$APPDATA\${APP}"

; Request application privileges for Windows Vista
RequestExecutionLevel user

!include "LogicLib.nsh"
!include "x64.nsh"

;--------------------------------

; Pages

Page directory
Page components
Page instfiles

;--------------------------------

; The stuff to install
Section "CheckNpgsqlSetupStatus 32bit" o32 ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath "$INSTDIR\x86"
  
  ; Put file there
  File /x "*.vshost.*" "bin\x86\DEBUG\*.*"
  
  Exec '"$OUTDIR\${APP}.exe"'
  
SectionEnd ; end the section


Section "CheckNpgsqlSetupStatus 64bit" o64 ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath "$INSTDIR\x64"

  ; Put file there
  File /x "*.vshost.*" "bin\x64\DEBUG\*.*"

  Exec '"$OUTDIR\${APP}.exe"'

SectionEnd ; end the section


Function .onInit
  ${IfNot} ${RunningX64}
    SectionSetFlags ${o64} 0
  ${EndIf}
FunctionEnd
