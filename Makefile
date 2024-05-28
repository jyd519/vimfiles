.PHONY: simple tags full clean

plugins=vim/plugged/fzf.vim vim/plugged/fzf vim/plugged/tcomment_vim \
				vim/plugged/nerdtree vim/plugged/papercolor-theme vim/plugged/splitjoin.vim \
				vim/plugged/vim-repeat vim/plugged/vim-easy-align \
				vim/plugged/nginx.vim

simple:
		rm -rf simple.zip
		7z a simple.zip -x'!vim/pack' -x'r!.git' -x'r!.DS_Store' -x'!vim/plugged' -x'!vim/lazy' \
				README.md example.vim ./vim > /dev/null 2>&1
		7z a simple.zip -x'r!.git' -x'r!.DS_Store' $(plugins)  > /dev/null 2>&1

full:
	rm -rf full.zip
	7z a full.zip -x'!vim/pack' -x'r!.git' -x'r!.DS_Store' -x'!vim/plugged' \
		README.md example.vim ./vim >/dev/null 2>&1
	7z a full.zip -x'r!.git' -x'r!.DS_Store' vim/lazy > /dev/null 2>&1

clean:
	rm -rf simple.zip full.zip
	find . -name '.DS_Store' -type f -delete

tags:
	ctags -R --languages=lua --exclude=vim/mysnippets --exclude=vim/examples --exclude=tests --exclude=mason-registry
