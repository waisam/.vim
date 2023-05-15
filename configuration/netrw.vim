let g:netrw_keepdir = 0
let g:netrw_winsize = 20
let g:netrw_banner = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'
" Normal mode Mapping
nnoremap <leader>dd :Lexplore %:p:h<CR>
nnoremap <leader>da :Lexplore<CR>
" Netrw View Navigatio
fu! NetrwMapping()
	nmap <buffer> H u
	nmap <buffer> h -^
	nmap <buffer> l <CR>

	nmap <buffer> . gh
	nmap <buffer> P <C-w>z

	nmap <buffer> L <CR>:Lexplore<CR>
	nmap <buffer> <leader>dd :Lexplore<CR>
endf
aug netrw
	autocmd!
	autocmd filetype netrw call NetrwMapping()
aug END
