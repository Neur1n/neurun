scriptencoding utf-8

function! neurun#config#Init() abort
  if !exists('g:neurun')
    let g:neurun = {
          \ 'autosave': 2,
          \ 'main': {'name': '', 'ft': ''},
          \ }
  endif
endfunction

function! neurun#config#MarkMain(...) abort
  if a:0
    let g:neurun.main.name = a:1
    let g:neurun.main.ft = a:2
  else
    let g:neurun.main.name = expand('%:p')
    let g:neurun.main.ft = &filetype
  endif
endfunction
