" Description: Autoload functions used by the vim-assterios plugin
" Version: ASTERIOS K19.2 and above

" ##############################################################################

" Get the directory where JSON schemas should be found, according to current
" configuration.
function! s:SchemasDir() abort
    return g:ast_kernel_dir . '/' . g:ast_product_name . '/schemas'
endfunction

" Shout an error message
function! s:ErrMsg(msg) abort
    echohl ErrorMsg
    echo 'vim-asterios: ' . a:msg
    echohl Normal
endfunction

" Attempt to find a plugin named `plugin` in the runtimepath: expects a file
" named `plugin/<pluginname>.vim`.
function! s:HasPlugin(plugin) abort
    return !empty(globpath(&runtimepath, 'plugin/' . a:plugin . '.vim'))
endfunction

" Normalize a path so that it only uses forward slashes. Only does something on
" Win32 platforms.
function! s:Normalize(path) abort
    if has('win32')
        return substitute(a:path, '\v\\', '/', 'g')
    endif
    return a:path
endfunction

" Convert a file path to a URI of the form `file:///path/to/the/file` for unix
" systems, and `file://drive:/path/to/the/file` on win32.
function! s:FilePathToURI(filepath) abort
    let l:norm_filepath = s:Normalize(a:filepath)
    if l:norm_filepath[0] !=# '/'
        let l:norm_filepath = '/' . l:norm_filepath
    endif
    return 'file://' . l:norm_filepath
endfunction


" ##############################################################################

" Cache for the return value of asterios#ListSchemas()
"
" FIXME: fails if g:ast_kernel_dir or g:ast_product_name changes
" after running one of these functions once
let s:schemas_cache = []

" Return a list of names of the schemas available with the current
" configuration. The result is cached to limit I/Os.
function! asterios#ListSchemas() abort
    if !empty(s:schemas_cache) | return s:schemas_cache | endif
    let l:schemas_files = glob(s:SchemasDir() . '/*.schema.json', v:true,
                \ v:true, v:true)
    let s:schemas_cache = map(l:schemas_files,
                \ { idx, f -> fnamemodify(f, ':t:r:r') })
    return s:schemas_cache
endfunction

" Cache for the return value of asterios#GlobalSchema()
"
" FIXME: fails if g:ast_kernel_dir or g:ast_product_name changes
" after running one of these functions once
let s:global_schema = {}

" Return a dict that can be encoded to a valid 'root' JSON Schema, referencing
" all the models available with the current configuration. It's petty, but at
" the moment ASTERIOS does not ship with such a root JSON schema: thus we have
" to build it.
function! asterios#GlobalSchema() abort
    if !empty(s:global_schema) | return s:global_schema | endif

    let s:global_schema = {
                \ '$schema': 'http://json-schema.org/draft-04/schema#',
                \ 'additionalProperties': v:false,
                \ 'type': 'object',
                \ 'properties' : {}
                \ }
    let l:schemasdir_uri = s:FilePathToURI(s:SchemasDir())

    for l:schema in asterios#ListSchemas()
        let l:schema_file = l:schema . '.schema.json'
        " read and decode the schema, to get the name of the definition for the
        " root object of that schema... Pretty convoluted, but there's no
        " other choice: e.g. for app it's 'app_Config', but for link_options it's
        " 'link_options_Link' :-/
        let l:json_schema = json_decode(join(
                    \ readfile(s:SchemasDir() . '/' . l:schema_file), "\n"))
        let l:def_link = l:json_schema['definitions']['__' . l:schema][
                    \ 'properties'][l:schema]['$ref']
        " all set, we can build the $ref for this root configuration item
        let s:global_schema.properties[l:schema] = {
                    \ '$ref': l:schemasdir_uri . '/' . l:schema_file
                    \         . l:def_link
                    \ }
    endfor

    return s:global_schema
endfunction

" ##############################################################################

" Dict used as a cache for coc.nvim configuration: stores the JSON files that
" are registered as ASTERIOS conf. files. Keys are JSON configuration files,
" value is an empty string.
"
" FIXME: fails if g:ast_kernel_dir or g:ast_product_name changes
" after running one of these functions once
let s:coc_config_cache = {}

" Configure coc.nvim so that {file} is linted as an ASTERIOS configuration file.
function! asterios#ConfSchema(file) abort
    if !g:ast_coc_enabled | return | endif

    if !s:HasPlugin('coc')
        call s:ErrMsg('coc.nvim does not seem to be installed!')
        return
    endif

    if (empty(a:file) || !filereadable(a:file))
        call s:ErrMsg('Cannot register this buffer: did you save the file?')
        return
    endif

    let l:normalized_file = s:Normalize(fnamemodify(a:file,':.'))
    if has_key(s:coc_config_cache, l:normalized_file) | return | endif

    " register this file as an ASTERIOS conf file, and call coc#config()
    let s:coc_config_cache[l:normalized_file] = ''
    call coc#config('json.schemas', [{
            \ 'fileMatch': keys(s:coc_config_cache),
            \ 'schema': asterios#GlobalSchema()
            \ }])
endfunction

" ##############################################################################

" Utility function that returns a string with the name of a global variable
" named {varname}, and its value
function! s:StrVar(varname) abort
    return 'g:' . a:varname . ': ' . get(g:, a:varname, 'N/A')
endfunction


" Print out a diagnostics message
function! asterios#EchoInfo() abort
    echom '**************************************'
    echom 'ASTERIOS PLUGIN STATUS'
    echom '**************************************'
    echom 'CONFIGURATION OPTIONS:'
    echom '  * ' . s:StrVar('ast_ale_enabled')
    echom '  * ' . s:StrVar('ast_coc_enabled')
    echom '  * ' . s:StrVar('ast_psyko_path')
    echom '      `--version` output: ' . system(g:ast_psyko_path . ' --version')

    echom '  * ' . s:StrVar('ast_kernel_dir')
    echom '      ' . (isdirectory(g:ast_kernel_dir) ?
                \ 'directory exists' : '/!\ NOT A DIRECTORY')

    echom '  * ' . s:StrVar('ast_product_name')
    echom '      ' . (isdirectory(g:ast_kernel_dir . '/' . g:ast_product_name) ?
                \ 'product exists' : '/!\ NO DIRECTORY FOR THIS PRODUCT')

    echom ' '

    echom 'PSYC LINTING WITH ALE:'
    echom '  * Enabled (g:ast_ale_enabled): '
                \ . (g:ast_ale_enabled ? 'ok' : 'NO!')
    echom '  * ALE plugin:                  '
                \ . (s:HasPlugin('ale') ? 'ok' : 'MISSING!')
    echom ' '
    echom 'JSON CONFIGURATION FILES AUTO-COMPLETION'
    echom '  * Enabled (g:ast_coc_enabled): '
                \ . (g:ast_coc_enabled ? 'ok' : 'NO!')
    echom '  * coc.nvim plugin:             ' .
                \ (s:HasPlugin('coc') ? 'ok' : 'MISSING!')
    echom '  * JSON Schemas available: ' . join(asterios#ListSchemas(), ', ')
    echom '  * Configuration files in current session:'
    echom '      ' . join(keys(s:coc_config_cache), "\n      ")
    echom ' '
endfunction
