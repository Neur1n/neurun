scriptencoding utf-8

if exists('g:loaded_runner')
  finish
endif
let g:loaded_runner = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

nmap <silent> <leader>ra :call runner#Run(1)<cr>
nmap <silent> <leader>rs :call runner#Run(0)<cr>

let &cpoptions = s:save_cpo
unlet s:save_cpo
