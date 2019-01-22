scriptencoding utf-8

try
  let s:plt = neutil#palette#Palette()
catch /^Vim\%((\a\+)\)\=:E/
  finish
endtry

function! neurun#highlight#Init() abort
  call neutil#palette#Highlight('NRi', s:plt.blue, s:plt.bgh, 'bold')
  call neutil#palette#Highlight('NRh', s:plt.green, s:plt.bgh, 'bold')
  call neutil#palette#Highlight('NRw', s:plt.yellow, s:plt.bgh, 'bold')
  call neutil#palette#Highlight('NRe', s:plt.red, s:plt.bgh, 'bold')
endfunction

function! neurun#highlight#Link(group) abort
  execute 'highlight link '.a:group.' NR'.neurun#status#Get('type')
endfunction
