scriptencoding utf-8

function! neurun#cmd#markdown#Run() abort
  if get(g:neu.run.main, 'name', '') !=# ''
    let l:main = g:neu.run.main.name
  else  " Current buffer
    let l:main = bufname('%')
  endif

  if has('unix')
    let l:browser = 'vivaldi'
  elseif has('win32')
    let l:browser = 'vivaldi'
  endif

  return [l:browser, l:main]
endfunction
