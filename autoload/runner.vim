scriptencoding utf-8

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:autosave = 2  " 0: do not; 1: save current buffer; 2: save all
let s:cb = {}
let s:curjob = 0
let s:interrupt = 0
let s:prefix = '[runner] '
let s:startup = 1
let s:start_stamp = 0

"***************************************************************** {{{ Messages
function! s:Highlight() abort
  let l:palette = neur1n#palette#Palette()

  call neur1n#palette#Highlight('RNormalMsg', l:palette.green[1], 'bg',
        \ l:palette.green[0], 'bg', 'bold')
  call neur1n#palette#Highlight('RWarningMsg', l:palette.yellow[1], 'bg',
        \ l:palette.yellow[0], 'bg', 'bold')
  call neur1n#palette#Highlight('RErrorMsg', l:palette.red[1], 'bg',
        \ l:palette.red[0], 'bg', 'bold')
endfunction

function! s:EchoMsg(type, msg) abort
  if a:type ==# 'n'
    echohl RNormalMsg
  elseif a:type ==# 'w'
    echohl RWarningMsg
  elseif a:type ==# 'e'
    echohl RErrorMsg
  else
    echohl WarningMsg
  endif
  echom s:prefix.a:msg
  echohl NONE
endfunction

function! s:QFMsg(msg) abort
  call setqflist([{'text': s:prefix.a:msg}], 'a')
endfunction

function! s:JoinData(data) abort
  let l:joined = ''
  for i in a:data
    let l:joined .= i
  endfor
  return l:joined
endfunction
" }}}

"************************************************************ {{{ Miscellaneous
function! s:AutoScroll() abort
  if &buftype ==# 'quickfix' && line('.') == line('$')
    silent  execute 'normal! Gzz'
  endif
endfunction

function! s:ShowElapsedTime() abort
  let l:cnt = reltimefloat(reltime(s:start_stamp))
  call s:QFMsg(printf('%f seconds elapsed.', l:cnt))
endfunction

function! s:DoAutoCmd(cmd) abort
  execute 'doautocmd User Runner'.a:cmd
endfunction
" }}}

"************************************************************** {{{ Job Control
function! s:JobStart(cmd) abort
  if has('nvim')
    let s:curjob = jobstart(a:cmd, s:cb)
  else
    let s:curjob = job_start(a:cmd, s:cb)
  endif

  if s:curjob > 0
    call s:EchoMsg('n', 'Running ')
    let s:start_stamp = reltime()
    call s:QFMsg(join(a:cmd))
    " call s:DoAutoCmd('Start')
  elseif s:curjob == 0
    call s:EchoMsg('e', 'Failed ✘')
    call s:QFMsg(join(a:cmd).': Invalid arguments or job table is full.')
    " call s:DoAutoCmd('Fail')
  elseif s:curjob == -1
    call s:EchoMsg('e', 'Failed ✘')
    call s:QFMsg(join(a:cmd).': Command is not executable.')
    " call s:DoAutoCmd('Fail')
  else
    call s:EchoMsg('e', 'Failed ✘')
    call s:QFMsg(join(a:cmd).': Unknown failure.')
    " call s:DoAutoCmd('Fail')
  endif
endfunction

function! s:JobStop() abort
  if exists('s:curjob')
    if has('nvim')
      if s:curjob > 0
        call jobstop(s:curjob)
      endif
    else
      if job_status(s:curjob) ==# 'run'
        call job_stop(s:curjob)
      endif
    endif

    " call s:ShowElapsedTime()
    call s:EchoMsg('w', 'Stopped ')

    let s:interrupt = 1
    unlet s:curjob
    " call s:DoAutoCmd('Stop')
  endif
endfunction

function! s:OutCB(jobid, data, event) abort
  let l:joined = s:JoinData(a:data)
  if l:joined !=# ''
    call s:QFMsg(l:joined)
  endif
endfunction

function! s:ErrCB(jobid, data, event) abort
  if !s:interrupt
    if v:shell_error == 0
      call s:EchoMsg('n', 'Finished ✓')
    else
      call s:EchoMsg('e', 'Error ✘')
    endif
  endif
  let s:interrupt = 0

  let l:joined = s:JoinData(a:data)
  if l:joined !=# ''
    let l:msg = printf('Shell returns %s. (Extra: %s)', v:shell_error, l:joined)
  else
    let l:msg = printf('Shell returns %s.', v:shell_error)
  endif

  call s:QFMsg(l:msg)
  call s:ShowElapsedTime()
endfunction

function! s:ExitCB(jobid, data, event) abort
  call s:QFMsg('Exited.')
endfunction
" }}}

"****************************************************************** {{{ Runnees
function! s:RunMarkdown() abort
  if has('unix')
    let l:browser = get(g:, 'runner.markdown.browser.unix', 'vivaldi')
  elseif has('win32')
    let l:browser = get(g:, 'runner.markdown.browser.win', 'vivaldi')
  endif

  return [l:browser, bufname('%')]
endfunction

function! s:RunPython() abort
  if filereadable('MAINFILE')  " Workspace
    let l:main = readfile('MAINFILE')[0]
  elseif get(g:, 'runner.python.main', '') !=# ''  " Global
    let l:main = g:runner.python.main
  else  " Current buffer
    let l:main = bufname('%')
  endif

  let l:python = get(g:, 'runner.python.provider', 'python3')

  return [l:python, l:main]
endfunction
" }}}

"********************************************************************* {{{ Main
function! runner#Run() abort
  if s:startup
    let s:cb = {
          \ 'on_stdout': function('s:OutCB'),
          \ 'on_stderr': function('s:ErrCB'),
          \ 'on_exit': function('s:ExitCB'),
          \ }
    let s:autosave = get(g:, 'runner.autosave', 2)
    let s:startup = 0

    call s:Highlight()
  endif

  if s:autosave == 1
    execute 'w'
  elseif s:autosave == 2
    execute 'wa'
  endif

  if &filetype ==# 'markdown'
    call s:JobStart(s:RunMarkdown())
  elseif &filetype ==# 'python'
    call s:JobStart(s:RunPython())
  endif
endfunction

function! runner#Stop() abort
  call s:JobStop()
endfunction

function! runner#ClearQF() abort
  call setqflist([], 'r')
endfunction
" }}}

let &cpoptions = s:save_cpo
unlet s:save_cpo
