call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.

Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'ycm-core/YouCompleteMe'
Plug 'w0rp/ale'
Plug 'majutsushi/tagbar'
Plug 'altercation/vim-colors-solarized'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}

" vim-oscyank
vnoremap <leader>c :OSCYank<CR>


" solarized
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized


" tagbar
let g:tagbar_autoshowtag = 1
map <silent> <F4> :TagbarToggle<CR>


" NERDTree
" Start NERDTree and put the cursor back in the other window.
autocmd VimEnter * NERDTree | wincmd p

autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
" Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror |endif
" nnoremap <C-n> :NERDTreeMirror<CR>:NERDTreeFocus<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
"let NERDTreeCustomOpenArgs = {'file':{'where': 't', 'keepopen': '1'}}
let NERDTreeCustomOpenArgs={'file': {'reuse': 'all', 'where': 't', 'keepopen': '1'}, 'dir': {}}

" YCM
nnoremap gd :YcmCompleter GoToDefinition<CR>
nnoremap gD :YcmCompleter GoToDeclaration<CR>
nnoremap gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>jf :YcmCompleter GoToCallers<CR>
nnoremap <leader>js :YcmCompleter GoToCallees<CR>
nnoremap gh <plug>(YCMHover)
let g:ycm_collect_identifiers_from_tags_files = 1
" 不使用语法检测
let g:ycm_show_diagnostics_ui = 0
" 从注释、字符串、tag文件中收集
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_auto_hover = ""
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_max_num_candidates = 15
let g:ycm_seed_identifiers_with_syntax = 1

" ale
let g:ale_sign_column_always = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" Write this in your vimrc file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
" You can disable this option too
" if you don't want linters to run on opening a file
let g:ale_lint_on_enter = 1
" 使用quickfix，禁用loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
" 始终显示标志栏
let g:ale_sign_column_always = 1
let g:ale_open_list = 0
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
let g:ale_keep_list_window_open = 0
"关闭ALE的补全
let g:ale_completion_enabled = 0
let g:ale_hover_cursor = 0
let g:ale_virtualtext_cursor = 1

call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

set encoding=UTF-8
set ts=4
set softtabstop=4
set expandtab
set shiftwidth=4

set nu
set backspace=2
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set updatetime=500

set splitbelow

set previewheight=15

au BufEnter ?* call PreviewHeightWorkAround()

function! PreviewHeightWorkAround()
  if &previewwindow
    exec 'setlocal winheight='.&previewheight
  endif
endfunc
