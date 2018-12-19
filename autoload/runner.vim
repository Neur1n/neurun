scriptencoding utf-8

" Examlpe:
" if !exists('g:runner')
"   let g:runner = {}
" endif

" let g:runner = {
"       \ 'autosave': 1,
"       \ 'markdown': {'browser': {'mac': 'vivaldi', 'unix': 'vivaldi', 'win': 'vivaldi'}},
"       \ 'python': {'provider': 'python3', 'main': ''},
"       \ }

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:autosave = 2  " 0: do not; 1: save current buffer; 2: save all
let s:startup = 1

function! runner#Run(async) abort
  let l:runner = s:Init(a:async)

  if s:autosave == 1
    execute 'w'
  elseif s:autosave == 2
    execute 'wa'
  endif

  if &filetype ==# 'markdown'
    execute l:runner.s:RunMarkdown()
  elseif &filetype ==# 'python'
    execute l:runner.s:RunPython()
  endif

  echohl WarningMsg
  echom '[runner] Starts.'
  echohl NONE
endfunction

function! s:Init(async) abort
  if s:startup
    let s:autosave = get(g:, 'runner.autosave', 2)
    let s:startup = 0
  endif

  if a:async
    if exists(':AsyncRun')
      return 'AsyncRun '
    else
      echohl ErrorMsg
      echom '[runner] Please install asyncrun.vim to enable async running.'
      echohl NONE
      return '!'
    endif
  else
    return '!'
  endif
endfunction

function! s:RunMarkdown() abort
  if has('unix')
    let l:browser = get(g:, 'runner.markdown.browser.unix', 'vivaldi')
  elseif has('win32')
    let l:browser = get(g:, 'runner.markdown.browser.win', 'vivaldi')
  endif

  return l:browser.' %'
endfunction

function! s:RunPython() abort
  if filereadable('MAINFILE')  " Workspace
    let l:main = readfile('MAINFILE')[0]
  elseif get(g:, 'runner.python.main', '') !=# ''  " Global
    let l:main = g:runner.python.main
  else  " Current buffer
    let l:main = '%'
  endif

  let l:python = get(g:, 'runner.python.provider', 'python3')

  return l:python.' '.l:main
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
