if exists('g:asterios_plugin_is_loaded')
    finish
endif

let g:asterios_plugin_is_loaded = 1

" ##############################################################################
" CONFIGURATION VARS
" ##############################################################################

" setup default values - see help for the documentation of these variables

let g:ast_psyko_path   = get(g:, 'ast_psyko_path' , 'psyko')
let g:ast_product_name = get(g:, 'ast_product_name' , 'ksim')
let g:ast_kernel_dir   = get(g:, 'ast_kernel_dir' , '')
let g:ast_coc_enabled  = get(g:, 'ast_coc_enabled', v:true)
let g:ast_ale_enabled  = get(g:, 'ast_ale_enabled', v:true)


" ##############################################################################
" COMMANDS DEFINITIONS
" ##############################################################################

" Returns the completion list for the `:AsteriosConfig` command. The signature
" is documented in |command-completion-custom|.
function! s:AstCommandComplete(ArgLead, CmdLine, CursorPos) abort
    return join(asterios#ListSchemas(), "\n")
endfunction

" define public commands - see help for their documentation
command! AsteriosConfig call asterios#ConfSchema(expand('%'))
command! AsteriosDiag   call asterios#EchoInfo()
