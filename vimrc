if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

match ErrorMsg '\s\+$'

":set expandtab"
":set tabstop=4"
