@REM packer.nvim install directory
git clone --depth=1 https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\opt\packer.nvim"

@REM On Windows, the config directory is $HOME/AppData/Local/nvim
@REM Clone nvim config to this directory
