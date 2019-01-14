

function! neurun#cmd#python#Run() abort
  if get(g:neu.run.main, 'name', '') !=# ''
    let l:main = g:neu.run.main.name
  else  " Current buffer
    let l:main = bufname('%')
  endif
  " if filereadable('MAINFILE')  " Workspace
  "   let l:main = readfile('MAINFILE')[0]
  " elseif get(g:neu.run.main, 'name', '') !=# ''  " Global
  "   let l:main = g:neu.run.main.name
  " else  " Current buffer
  "   let l:main = bufname('%')
  " endif

  if has('unix')
    let l:python = 'python3'
  elseif has('win32')
    let l:python = 'python'
  endif

  return [l:python, '-u', l:main]
endfunction
