" open ranger when vim open a directory
let g:ranger_replace_netrw = 1 
let g:ranger_map_keys = 0
let g:ranger_command_override = 'ranger -c' 
noremap <leader>f :RangerNewTab<CR>
