## ctags

```sh
# 生成tags文件
ctags -R --exclude=.git--exclude=vendor --exclude=node_modules --exclude=db --exclude=log .

# c++
ctags -R --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++
```
