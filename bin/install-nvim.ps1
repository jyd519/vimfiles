param (
  [switch]$nightly = $false
)


$local="nvim-win64.zip"
$localdir = "nvim-win64" 
$destinationPath = "c:\tools"
$url="https://github.com/neovim/neovim/releases/download/stable/nvim-win64.zip"
if ($nightly) {
  $url="https://github.com/neovim/neovim/releases/download/nightly/nvim-win64.zip"
  $local="nvim-win64-nightly.zip"
}

if ( -not (Test-Path $local)) {
  Write-Host "Downloading $url to $local"  
  $proxy=$env:HTTP_PROXY
  if ($proxy -ne "") {
    Invoke-WebRequest -Uri $url -OutFile $local -Proxy $proxy
  } else {
    Invoke-WebRequest -Uri $url -OutFile $local
  }
}

Remove-Item $localdir -Recurse -ErrorAction Ignore -Force

Expand-Archive $local -DestinationPath .

try {
    Move-Item -Path $localdir -Destination $destinationPath -Force
    Remove-Item "$destinationPath\nvim" -Recurse -ErrorAction Ignore
    Rename-Item -Path "$destinationPath\nvim-win64" -NewName nvim
    Write-Host "Nvim Intalled: $destinationPath"
    Remove-Item $local -Recurse -ErrorAction Ignore
} catch {
    Write-Host "文件夹移动失败。错误: $_"
    Remove-Item $localdir -Recurse -ErrorAction Ignore -Force
    exit 1
}

exit
