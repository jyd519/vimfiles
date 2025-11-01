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
	# excludes some large plugins
	rm -rf full.zip
	7z a full.zip -x'!vim/pack' -x'r!.git' -x'r!.DS_Store' \
		-x'r!tests/' \
		-x'!vim/plugged' \
		-x'!vim/lazy/ale' \
		-x'!vim/lazy/vim-test' \
		-x'!vim/lazy/go.nvim' -x'!vim/lazy/nvim-dap-go.nvim' \
		-x'!vim/lazy/tailwin*' \
		-x'!vim/lazy/ts-*' \
		-x'!vim/lazy/refactoring.nvim' \
		-x'!vim/lazy/splitjoin.vim' \
		-x'!vim/lazy/kulala.nvim' \
		-x'!vim/lazy/codecompanion.nvim' \
		-x'!vim/lazy/crates.nvim' \
		-x'!vim/lazy/mcphub.nvim' \
		README.md example.vim ./vim >/dev/null 2>&1


clean:
	rm -rf simple.zip full.zip
	find . -name '.DS_Store' -type f -delete

tags:
	ctags -R --languages=lua --exclude=vim/mysnippets --exclude=vim/examples --exclude=tests --exclude=mason-registry
