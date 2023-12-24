$ROOT=$PSScriptRoot

$SIGNER="c:/tools/sign.py"
$env:PATH += ";C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.22621.0\\x64"
$files = @("etlock.exe", "etlock.dll", "etlock64.exe", "etlock64.dll", "util.dll")
foreach ($file in $files) {
  & "python3" $SIGNER "$ROOT\\$file" -s 悦考系统
}

7z a -tzip etlock.zip $files
scp.exe etlock.zip root@172.16.21.222:/var/ata/joytest/DEV/win-x86/