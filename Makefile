simple=vim/plugged/fzf vim/plugged/fzf.vim vim/plugged/tcomment_vim \
				vim/plugged/nerdtree vim/plugged/papercolor-theme vim/plugged/splitjoin.vim \
				vim/plugged/coc.nvim

simple:
		rm -rf vimfiles.zip
		7z a vimfiles.zip -x'!vim/pack' -x'r!.git' -x'r!.DS_Store' -x'!vim/plugged' README.md ./vim
		7z a vimfiles.zip -x'r!.git' -x'r!.DS_Store' $(plugins)