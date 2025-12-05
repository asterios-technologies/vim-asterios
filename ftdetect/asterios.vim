" Filetype detection for Tak, Bgt and Psy languages
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18, K19

" vint: -ProhibitAutocmdWithNoGroup
" (autocmds in ftdetect are automatically grouped)
au BufRead,BufNewFile *.tak      set filetype=tak
au BufRead,BufNewFile *.bgt      set filetype=bgt
au BufRead,BufNewFile *.psy      set filetype=psy
au BufRead,BufNewFile *.psyh     set filetype=psy
au BufRead,BufNewFile *.psyt     set filetype=psy
au BufRead,BufNewFile *.khic     set filetype=khic

" JSON configuration files: autocmd only defined when *reading* a file: we can't
" autocomplete if we don't have a file on disk
au BufRead {*.,}{app,error_handlers,external_source,ktools,link_options,partition,psymodule}.json
            \ call asterios#ConfSchema(expand('%'))
