# Jai.vim

Syntax highlighting for [Jonathan Blow's](https://twitter.com/Jonathan_Blow) programming language **Jai**.

## Configuration

By default, case labels are indented. If you don't want that, you can disable it:
```
let b:jai_indent_options = {'case_labels':0}
```


## Installation

If you use pathogen clone this plugin to `~/.vim/bundle`

```bash
git clone https://github.com/jansedivy/jai.vim.git ~/.vim/bundle
```

In general, for other plugin managers you have to add configuration line in `~/.vimrc`.

```viml
" vim-plug
Plug 'jansedivy/jai.vim'

" NeoBundle
NeoBundle 'jansedivy/jai.vim'

" Vundle
Plugin 'jansedivy/jai.vim'
```

### Manual installation

* copy files to your `~/.vim` folder
