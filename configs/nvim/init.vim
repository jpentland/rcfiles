" Leader
:let mapleader = ","

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
if has('nvim-0.6.1')
  Plug 'neovim/nvim-lspconfig'
  Plug 'folke/lsp-colors.nvim'
endif
Plug 'cespare/vim-toml'
if has('nvim-0.6')
  Plug 'github/copilot.vim'
endif
Plug 'yggdroot/indentLine'
Plug 'neomake/neomake'
call plug#end()

" Color options
:colorscheme peachpuff

" lsp setup
if has('nvim-0.6.1')
lua << EOF
  require("lspconfig").pylsp.setup{}
  require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
  })
EOF
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
endif
set completeopt-=preview
autocmd Filetype javascript setlocal sw=2
autocmd Filetype vue setlocal sw=2

" Return to previous point in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Editor Options
:set expandtab
:set tabstop=4
:set shiftwidth=4
filetype plugin indent on
syntax on
"highlight Normal ctermfg=white ctermbg=NONE
:set so=5
set tags=./tags,tags;$HOME
:set laststatus=0 ruler

" Enable indent lines
:let g:indentLine_enabled=1
:let g:indentLine_color_term=239
:let g:indentLine_char=''

" Enable neomake
:let g:neomake_python_enabled_makers = ['pylint']
call neomake#configure#automake('nrwi', 500)

" Enable linting for python
:let g:python_lint_enabled=1

" highlight
:hi LspDiagnosticsDefaultError ctermfg=lightred
:hi LspDiagnosticsUnderlineError ctermbg=lightred ctermfg=black
:hi LspDiagnosticsDefaultWarning ctermfg=lightyellow
:hi LspDiagnosticsSignError ctermbg=red ctermfg=black
:hi LspDiagnosticsUnderlineWarning ctermbg=lightyellow ctermfg=black
:hi LspDiagnosticsSignWarning ctermbg=yellow ctermfg=black

:hi SignColumn ctermbg=black
:hi SpellBad ctermbg='Magenta' ctermfg=black
:hi Search ctermbg=3 ctermfg=black

" Buffer Navication
map <tab> :bNext<CR>
map <C-b> :Buffers<CR>
map <C-k> :bd<CR>

" Nice keyboard shortcuts
nnoremap Y y$
nnoremap n nzzzv
nnoremap U Uzzzv
nnoremap <C-p> :Files<Cr>
nnoremap <leader>p :Tags<Cr>
nnoremap <leader>/ :Rg<Cr>

" Relative number
:set number relativenumber
:set nu rnu
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Highlight lines longer than 80 characters
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

"File types
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal spell textwidth=72
au BufReadPost,BufNewFile .xmobarrc setlocal ft=haskell
autocmd filetype javascript setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2

" Email
au BufRead /tmp/mutt-* set tw=72
augroup filetypedetect
  autocmd BufRead,BufNewFile *mutt-*              setfiletype mail
augroup END
autocmd Filetype mail setlocal spell

if has('nvim-0.6')
  autocmd Filetype mail Copilot disable

  " Only enable copilot if the file ".copilot" exists in the current directory
  autocmd VimEnter * Copilot disable
  if filereadable('.copilot')
      autocmd VimEnter * Copilot enable
  endif
  nnoremap <leader>c :Copilot enable<CR>
endif

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-j> <esc>:m .+1<CR>==i
inoremap <C-k> <esc>:m .-2<CR>==i
inoremap <leader>j :m .+1<CR>==
inoremap <leader>k :m .-2<CR>==

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call s:CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call s:CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call s:CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call s:CombineSelection(<line1>, <line2>, '0336')

function! s:CombineSelection(line1, line2, cp)
  execute 'let char = "\u'.a:cp.'"'
  execute a:line1.','.a:line2.'s/\%V[^[:cntrl:]]/&'.char.'/ge'
endfunction

" undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap , ,<c-g>u
inoremap [ [<c-g>u
inoremap ] ]<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u
inoremap = =<c-g>u
inoremap <space> <space><c-g>u

" gpg en/decrypt
xnoremap <leader>g :!gpg -d -q<CR>
xnoremap <leader>G :!gpg -e -q<CR>
