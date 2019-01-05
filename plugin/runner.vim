scriptencoding utf-8

if exists('g:loaded_runner')
  finish
endif
let g:loaded_runner = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

nnoremap <silent> <leader>rr :call runner#Run()<CR>
nnoremap <silent> <leader>rs :call runner#Stop()<CR>
nnoremap <silent> <leader>rc :call runner#ClearQF()<CR>
nnoremap <silent> <leader>qf :copen<CR>

let &cpoptions = s:save_cpo
unlet s:save_cpo
