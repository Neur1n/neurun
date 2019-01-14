scriptencoding utf-8

try
  let s:palette = neutil#palette#Palette()
catch /^Vim\%((\a\+)\)\=:E/
  finish
endtry

function! neurun#highlight#Init() abort
  call neutil#palette#Highlight('NRi', s:palette.blue, 'bg', 'bold')
  call neutil#palette#Highlight('NRh', s:palette.green, 'bg', 'bold')
  call neutil#palette#Highlight('NRw', s:palette.yellow, 'bg', 'bold')
  call neutil#palette#Highlight('NRe', s:palette.red, 'bg', 'bold')
endfunction

function! neurun#highlight#Link(group) abort
  execute 'highlight link '.a:group.' NR'.neurun#status#Get('type')
endfunction
