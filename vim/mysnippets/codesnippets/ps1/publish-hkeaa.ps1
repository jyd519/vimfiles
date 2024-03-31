$ROOT=$PSScriptRoot

$SIGNER="sign.py"
$env:PATH += ";C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.22621.0\\x64"
$files = @("etlock.exe", "etlock.dll", "etlock64.exe", "etlock64.dll", "util.dll", "joysec.exe")
foreach ($file in $files) {
  & $SIGNER "$ROOT\\$file" -s "HKEAA Delivery Module" 
}

7z a -tzip etlock-hkeaa.zip $files
scp.exe etlock-hkeaa.zip root@172.16.21.222:/var/ata/joytest/DEV/win-x86/