scriptencoding utf-8

function! neurun#config#Init() abort
  if !exists('g:neu')
    let g:neu = {}
  endif

  if !exists('g:neu.run')
    let g:neu.run = {
          \ 'autosave': 2,
          \ 'main': {'name': '', 'ft': ''},
          \ }
  endif
endfunction

function! neurun#config#MarkMain(...) abort
  if a:0
    let g:neu.run.main.name = a:1
    let g:neu.run.main.ft = a:2
  else
    let g:neu.run.main.name = expand('%:p')
    let g:neu.run.main.ft = &filetype
  endif
endfunction
