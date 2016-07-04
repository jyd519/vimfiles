" This is *NOT* syntax augmentation (i.e. not designed for use in vimfiles/after).
" It should be placed in vimfiles/syntax and overrides the one in $VIMRUNTIME/syntax
" Written w/o any concern of forward/backward compatibility, used gVim 6.4 and NSIS 2.16
" It was intentional to NOT link highlights to predefined groups, therefore
" the usual colorschemes do not apply. Caveat emptor!
"
" (C) A. Alper ATICI <alper@atici.net>
"

syntax case ignore

syntax keyword nsiAttribGen AddBrandingImage AllowRootDirInstall AutoCloseWindow BGFont BGGradient BrandingText
\                           Caption ChangeUI CheckBitmap CompletedText ComponentText CRCCheck
\                           DetailsButtonText DirText DirVar DirVerify FileErrorText
\                           Icon InstallButtonText InstallColors InstallDir InstallDirRegKey InstProgressFlags
\                           InstType LicenseBkColor LicenseData LicenseForceSelection LicenseText MiscButtonText
\                           Name OutFile WindowIcon XPStyle SetFont
\                           ShowInstDetails ShowUninstDetails SilentInstall SilentUnInstall SpaceTexts SubCaption
\                           UninstallButtonText UninstallCaption UninstallIcon UninstallSubCaption UninstallText

syntax keyword nsiAttribCFlags AllowSkipFiles FileBufSize SetCompress SetCompressor SetCompressorDictSize
\                           SetDatablockOptimize SetDateSave SetOverwrite SetPluginUnload

syntax keyword nsiAttribVI  VIAddVersionKey VIProductVersion


syntax keyword nsiInstBasic Delete Exec ExecShell ExecWait File Rename ReserveFile RMDir SetOutPath

syntax keyword nsiInstRegINI DeleteINISec DeleteINIStr DeleteRegKey DeleteRegValue EnumRegKey EnumRegValue
\                           ExpandEnvStrings FlushINI ReadEnvStr ReadINIStr ReadRegDWORD ReadRegStr WriteINIStr
\                           WriteRegBin WriteRegDWORD WriteRegStr WriteRegExpandStr

syntax keyword nsiInstGen   CallInstDLL CopyFiles CreateDirectory CreateShortCut GetDLLVersion GetDLLVersionLocal
\                           GetFileTime GetFileTimeLocal GetFullPathName GetTempFileName SearchPath
\                           SetFileAttributes RegDLL UnRegDLL

syntax keyword nsiInstFlowCont Abort Call ClearErrors GetCurrentAddress GetFunctionAddress GetLabelAddress Goto
\                           IfAbort IfErrors IfFileExists IfRebootFlag IfSilent IntCmp IntCmpU
\                           MessageBox Return Quit SetErrors StrCmp StrCmpS

syntax keyword nsiInstFile  FileClose FileOpen FileRead FileReadByte FileSeek FileWrite FileWriteByte
\                           FindClose FindFirst FindNext

syntax keyword nsiInstMisc  WriteUninstaller GetErrorLevel GetInstDirError InitPluginsDir Nop SetErrorLevel
\                           SetShellVarContext Sleep StrCpy StrLen Exch Pop Push IntFmt IntOp Reboot SetRebootFlag
\                           LogSet LogText AddSize SectionIn

syntax keyword nsiInstSect  SectionSetFlags SectionGetFlags SectionSetText SectionGetText SectionSetInstTypes
\                           SectionGetInstTypes SectionSetSize SectionGetSize SetCurInstType GetCurInstType
\                           InstTypeSetText InstTypeGetText

syntax keyword nsiInstUI    BringToFront CreateFont DetailPrint EnableWindow FindWindow GetDlgItem HideWindow
\                           IsWindow LockWindow SendMessage SetAutoClose SetBrandingImage SetDetailsView
\                           SetDetailsPrint SetCtlColors SetSilent ShowWindow

syntax keyword nsiInstLang  LoadLanguageFile LangString LicenseLangString


syntax keyword nsiCommands  Var Page PageEx UninstPage Function FunctionEnd SectionGroup SectionGroupEnd Section SectionEnd


syntax match nsiPreproc1    "\s*!\(include\|addincludedir\|addplugindir\|appendfile\|cd\|delfile\|echo\|error\|execute\|packhdr\|system\|tempfile\|warning\|verbose\)"
syntax match nsiPreproc2    "\s*!\(define\|undef\|ifn\?def\|ifmacron\?def\|if\|else\|endif\|insertmacro\|macro\(end\)\?\)"


syntax match nsiSwitch      "\s\+/\(GLOBAL\|[oarxe]\_s\|ITALIC\|UNDERLINE\|STRIKE\|TRIM\(LEFT\|RIGHT\|CENTER\)\|windows\|NOCUSTOM\|COMPONENTSONLYONCUSTOM\|gray\|SOLID\|FINAL\|REBOOTOK\|nonfatal\|ifempty\|NOUNLOAD\|SILENT\|FILESONLY\|SHORT\|SD\|RESIZETOFIT\|BRANDING\|set\|ENABLECANCEL\|math\|\(utc\)\?date\)"

syntax match nsiArgs        "\s\+\(RO\|left\|right\|top\|bottom\|true\|false\|on\|off\|all\|force\|auto\|leave\|smooth\|colored\|checkbox\|radiobuttons\|hide\|\(never\)\?show\|normal\|silent\(log\)\?\|lzma\|bzip2\|gzip\|try\|ifnewer\|ifdiff\|lastused\|manual\|alwaysoff\|current\|none\|listonly\|textonly\|both\|custom\|SW_SHOWNORMAL\|SW_SHOWMAXIMIZED\|SW_SHOWMINIMIZED\|SW_HIDE\|HKCR\|HKEY_CLASSES_ROOT\|HKLM\|HKEY_LOCAL_MACHINE\|HKCU\|HKEY_CURRENT_USER\|HKU\|HKEY_USERS\|HKCC\|HKEY_CURRENT_CONFIG\|HKDD\|HKEY_DYN_DATA\|HKPD\|HKEY_PERFORMANCE_DATA\|SHCTX\|SHELL_CONTEXT\|IDABORT\|IDCANCEL\|IDIGNORE\|IDNO\|IDOK\|IDRETRY\|IDYES\)\_s\@="
                           
syntax match nsiParams      "\s\+\(/CUSTOMSTRING\|/LANG\|[0-4]\|/oname\|/timeout\|/IMGID\)="

syntax match nsiFlags       "\(\s\+\||\)\(ALT\|CONTROL\|EXT\|SHIFT\|[fF][12][0-9]\?\|NORMAL\|FILE_ATTRIBUTE_NORMAL\|ARCHIVE\|FILE_ATTRIBUTE_ARCHIVE\|HIDDEN\|FILE_ATTRIBUTE_HIDDEN\|OFFLINE\|FILE_ATTRIBUTE_OFFLINE\|READONLY\|FILE_ATTRIBUTE_READONLY\|SYSTEM\|FILE_ATTRIBUTE_SYSTEM\|TEMPORARY\|FILE_ATTRIBUTE_TEMPORARY\|MB_OK\|MB_OKCANCEL\|MB_ABORTRETRYIGNORE\|MB_RETRYCANCEL\|MB_YESNO\|MB_YESNOCANCEL\|MB_ICONEXCLAMATION\|MB_ICONINFORMATION\|MB_ICONQUESTION\|MB_ICONSTOP\|MB_TOPMOST\|MB_SETFOREGROUND\|MB_RIGHT\|MB_RTLREADING\|MB_DEFBUTTON1\|MB_DEFBUTTON2\|MB_DEFBUTTON3\|MB_DEFBUTTON4\)\(\_s\||\)\@="

syntax match nsiComment     /\(^\|\s\+\)[;#].*/
syntax match nsiComment2    "/\*\(\_[^*/]\|\*\_[^/]\|[^*]\?/\)*\*/"
syntax match nsiVar         /\$\w\+/
syntax match nsiDefConst    /\${\w\+}/
syntax match nsiStrConst    /\$\\[rnt]/
syntax match nsiLangStr     /\$(\w\+)/
syntax match nsiPlugin      /\<\f\+::\k\+\>/
syntax match nsiLabel       /[^: \t]\+:\(\s\|$\)/ contains=nsiDefConst
syntax match nsiLabelGlob   /\.[^: \t]\+:\(\s\|$\)/ contains=nsiDefConst
syntax region nsiString     start=/'/ skip="\$\\'" end=/'/ contains=nsiVar,nsiDefConst,nsiLangStr,nsiStrConst
syntax region nsiString2    start=/"/ skip='\$\\"' end=/"/ contains=nsiVar,nsiDefConst,nsiLangStr,nsiStrConst
syntax region nsiString3    start=/`/ skip='\$\\`' end=/`/ contains=nsiVar,nsiDefConst,nsiLangStr,nsiStrConst


hi nsiAttribGen                      guifg=Blue guibg=White
hi link nsiAttribCFlags nsiAttribGen
hi link nsiAttribVI     nsiAttribGen

hi nsiInstBasic                      guifg=DarkBlue guibg=White
hi link nsiInstRegINI   nsiInstBasic
hi link nsiInstGen      nsiInstBasic
hi link nsiInstFlowCont nsiInstBasic
hi link nsiInstFile     nsiInstBasic
hi link nsiInstMisc     nsiInstBasic
hi link nsiInstSect     nsiInstBasic
hi link nsiInstUI       nsiInstBasic
hi link nsiInstLang     nsiInstBasic

hi nsiCommands                       gui=bold guifg=DarkBlue guibg=White

hi nsiPreproc1                       gui=bold guifg=DarkGreen guibg=White
hi nsiPreproc2                       guifg=DarkGreen guibg=White

hi nsiArgs                           guifg=Red guibg=White
hi nsiFlags                          gui=bold guifg=LightRed guibg=White
hi nsiParams                         guifg=Blue guibg=White
hi nsiSwitch                         guifg=Magenta guibg=White
hi nsiComment                        gui=italic guifg=LightBlue guibg=White
hi nsiComment2                       gui=italic guifg=Grey guibg=White
hi nsiString                         guifg=DarkCyan guibg=White
hi link nsiString2 nsiString
hi link nsiString3 nsiString
hi nsiStrConst                       guifg=darkgray guibg=White
hi nsiVar                            guifg=DarkRed guibg=White
hi nsiDefConst                       gui=italic guifg=Brown guibg=White
hi nsiLangStr                        guifg=DarkMagenta guibg=White
hi nsiPlugin                         guifg=Black guibg=lightyellow
hi nsiLabel                          gui=underline guifg=Darkcyan guibg=Lightgrey
hi nsiLabelGlob                      gui=underline,bold guifg=Darkcyan guibg=Lightgrey


let b:current_syntax = "nsis"

syntax sync minlines=60

