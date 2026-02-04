!define APP_NAME "Osdag"
!define APP_VERSION "2026.02.0.0"
!define APP_PUBLISHER "Osdag Team IIT Bombay"

OutFile "Osdag-v${APP_VERSION}-win.exe"
Name "${APP_NAME}"
VIProductVersion "${APP_VERSION}"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "FileVersion" "${APP_VERSION}"
VIAddVersionKey "FileDescription" "Osdag version ${APP_VERSION} Windows Installer"
VIAddVersionKey "LegalCopyright" "© 2026 Osdag Team, IIT Bombay"
BrandingText 'Osdag v${APP_VERSION}'

RequestExecutionLevel user

!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

!define MUI_WELCOMEPAGE_TITLE "This Setup will guide you through the installation of Osdag  $\r$\n$\r$\nPLEASE UNINSTALL ANY EARLIER VERSION OF OSDAG on your system before going ahead.$\r$\n $\r$\nPlease click Next only after uninstalling the earlier version" 
!define MUI_FINISHPAGE_TITLE "Installation Complete"
!define MUI_FINISHPAGE_TEXT "Osdag has been successfully installed."        
!define MUI_ABORTWARNING                
!define MUI_ICON "..\Osdag.ico"           
!define MUI_UNICON "..\Osdag.ico"          
; !define MUI_HEADERIMAGE          
; !define MUI_HEADERIMAGE_BITMAP "..\Osdag_header.bmp" 
; !define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
; !define MUI_HEADERIMAGE_UNBITMAP "..\Osdag_header.bmp" 
; !define MUI_HEADERIMAGE_UNBITMAP_NOSTRETCH
!define MUI_LICENSEPAGE_CHECKBOX
!define MUI_LICENSEPAGE_CHECKBOX_TEXT "I accept the terms in the license agreement"
!define MUI_DIRECTORYPAGE_TEXT_TOP "Select Installation Directory"
!define MUI_COMPONENTSPAGE_TEXT_TOP "Check the plugins you want to Install and uncheck those you don't want to install. Click Next to continue."
!define MUI_COMPONENTSPAGE_TEXT_COMPLIST "Select additional plugins to install:"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Launch Osdag"
!define MUI_FINISHPAGE_RUN_FUNCTION LaunchOsdag
!define MUI_UNFINISHPAGE_TITLE "Uninstallation Complete"
!define MUI_UNFINISHPAGE_TEXT "Osdag was successfully removed from your system."

!insertmacro MUI_PAGE_WELCOME           
!insertmacro MUI_PAGE_LICENSE "..\license.txt" 
!insertmacro MUI_PAGE_COMPONENTS        
!insertmacro MUI_PAGE_DIRECTORY
page custom DirectoryConfirmationPage
!insertmacro MUI_PAGE_INSTFILES     
!insertmacro MUI_PAGE_FINISH   
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

Function .onInit
    StrCpy $INSTDIR "$PROFILE\Osdag" 
FunctionEnd

Function DirectoryConfirmationPage

    nsDialogs::Create 1018
    Pop $0
    
    ${If} $0 == error
        Abort
    ${EndIf}
    ${NSD_CreateLabel} 0 0 100% 40u "Osdag will be installed at:$\r$\n$INSTDIR\Osdag$\r$\n$\r$\nIf you want to change the location, click Back to return to the directory selection page."
    Pop $1
    nsDialogs::Show

FunctionEnd

Section "Osdag" SEC_Main
    SectionIn RO    
    SetOutPath "$INSTDIR\Osdag"

    ; copy files to install\Osdag folder
    File /r "..\osdag-pixi\.pixi"
    File /r "..\osdag-pixi\icons"
    File "..\license.txt"
    File "..\run.bat"
    File "..\update.bat"
    File "..\nircmd.exe"

    ; create uninstaller for osdag
    WriteUninstaller "$INSTDIR\Osdag\Uninstall.exe"

    ; Registry keys
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayName" "${APP_NAME}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayIcon" "$INSTDIR\Osdag\icons\Osdag_App_icon.ico"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "UninstallString" "$INSTDIR\Osdag\Uninstall.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "InstallLocation" "$INSTDIR\Osdag"
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "NoModify" 1
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "NoRepair" 1

SectionEnd


; optional
Section "Startmenu Shortcut" SEC_SM_Shortcuts
    CreateDirectory "$SMPROGRAMS\Osdag"

    CreateShortcut "$SMPROGRAMS\Osdag\Osdag.lnk" "$INSTDIR\Osdag\nircmd.exe" 'exec hide "$INSTDIR\Osdag\run.bat"' "$INSTDIR\Osdag\icons\Osdag_App_icon.ico" 0
   
    CreateShortcut "$SMPROGRAMS\Osdag\Uninstall.lnk" "$INSTDIR\Osdag\Uninstall.exe" "" "$INSTDIR\Osdag\icons\Osdag_App_icon.ico" 0
SectionEnd

; optional
Section "Desktop Shortcut" SEC_DESK_Shortcuts

    CreateShortcut "$DESKTOP\Osdag.lnk" "$INSTDIR\Osdag\nircmd.exe" 'exec hide "$INSTDIR\Osdag\run.bat"' "$INSTDIR\Osdag\icons\Osdag_App_icon.ico" 0

SectionEnd


; optional
Function LaunchOsdag
    Exec '"$INSTDIR\Osdag\nircmd.exe" exec hide "$INSTDIR\Osdag\.pixi\envs\default\Scripts\osdag.exe"'
FunctionEnd

Function un.onInit
    MessageBox MB_YESNO|MB_ICONQUESTION "Are you sure you want to uninstall Osdag?" IDYES +2
    Abort
    ReadRegStr $INSTDIR HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag" "InstallLocation"
FunctionEnd

Section "Uninstall"

    RMDir /r "$INSTDIR"
   
    Delete "$DESKTOP\Osdag.lnk"
    Delete "$SMPROGRAMS\Osdag\Osdag.lnk"
    Delete "$SMPROGRAMS\Osdag\Uninstall.lnk"
    RMDir /r "$SMPROGRAMS\Osdag"

    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\Osdag"

SectionEnd
