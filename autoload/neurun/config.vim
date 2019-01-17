scriptencoding utf-8

let s:ft_map = {
      \ 'md': 'markdown',
      \ 'py': 'python',
      \ }

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

    if len(a:000) == 2
      let g:neu.run.main.ft = a:2
    elseif len(a:000) == 1
      let l:ext = fnamemodify(a:1, ':e')
      let g:neu.run.main.ft = s:ft_map[l:ext]
    endif
  else
    let g:neu.run.main.name = expand('%:p')
    let g:neu.run.main.ft = &filetype
  endif
endfunction
