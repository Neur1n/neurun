scriptencoding utf-8

" Examlpe:
" if !exists('g:runner')
"   let g:runner = {}
" endif

" let g:runner = {
"       \ 'autosave': 1,
"       \ 'markdown': {'async': 0, 'browser': {'mac': 'vivaldi', 'unix': 'vivaldi', 'win': 'vivaldi'}},
"       \ 'python': {'async': 1, 'provider': 'python3', 'main': ''},
"       \ }

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:autosave = 2  " 0: do not; 1: save current buffer; 2: save all
let s:startup = 1
let s:runner = ''

function! runner#Run() abort
  if s:autosave == 1
    execute 'w'
  elseif s:autosave == 2
    execute 'wa'
  endif

  if &filetype ==# 'markdown'
    execute s:RunMarkdown()
  elseif &filetype ==# 'python'
    execute s:RunPython()
  endif

  echohl WarningMsg
  echom '[runner] Starts.'
  echohl NONE
endfunction

function! s:Init(async) abort
  if s:startup
    let s:autosave = get(g:, 'runner.autosave', 2)

    if a:async && exists(':AsyncRun')
      let s:runner = 'AsyncRun '
    else
      let s:runner = '!'
    endif
    let s:startup = 0
  endif
endfunction

function! s:RunMarkdown() abort
  let l:async = get(g:, 'runner.markdown.async', 1)
  call s:Init(l:async)

  if has('unix')
    let l:browser = get(g:, 'runner.markdown.browser.unix', 'vivaldi')
  elseif has('win32')
    let l:browser = get(g:, 'runner.markdown.browser.win', 'vivaldi')
  endif

  return s:runner.l:browser.' %'
endfunction

function! s:RunPython() abort
  let l:async = get(g:, 'runner.python.async', 1)
  call s:Init(l:async)

  if filereadable('MAINFILE')  " Workspace
    let l:main = readfile('MAINFILE')[0]
  elseif get(g:, 'runner.python.main', '') !=# ''  " Global
    let l:main = g:runner.python.main
  else  " Current buffer
    let l:main = '%'
  endif

  let l:python = get(g:, 'runner.python.provider', 'python3')

  return s:runner.l:python.' '.l:main
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
