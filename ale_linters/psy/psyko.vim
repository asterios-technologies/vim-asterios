" Description: Integration with ALE to run psyko as a linter for PsyC source
"              files
" Version: Compatible with ASTERIOS Developer K19.2

call ale#Set('psy_psyko_options', '--color no')
call ale#Set('psy_psyko_jsonconf', [])

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Regexp to match an error message issued by psyko. As a reminder, capturing
" groups indices:
"
" 1 - message type (fatal, error or warning)
" 2 - error code
" 3 - complete position string - should not be used
" 4 - file name
" 5 - line number
" 6 - col number
" 7 - error message
let s:psyko_error_regex =
            \ '\v\w+\>(fatal|error|warning)\>' .
            \ '\s+(\w+):\s+((.*):(\d+):(\d+):\s+)?(.*)$'

" Const map that matches message types of psyko to a message type identifier for
" ale#linter#Define().
let s:psyko_log_msglevel = {
                    \ 'fatal': 'E',
                    \ 'error': 'E',
                    \ 'warning': 'W',
                    \ '': 'E'
                    \}

" Regex to identify the leading error message of psyko, that should not be
" passed to ALE as it does not identify a file or a position: the following
" messages do.
let s:psyko_root_error_msg_regex = '\v\(faulty command below\):'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Build the command line that calls psyko for linting the current file,
" identified by `buffer`
function! s:GetCommand(buffer) abort
    " prepare a temp file for the output db
    let l:tmpoutputdb = tempname() . '.ks'
    call ale#command#ManageFile(a:buffer, l:tmpoutputdb)

    let s:cmdline = '%e '
    \   . ale#Var(a:buffer, 'psy_psyko_options')
    \   . ' --product ' . g:ast_product_name
    \   . ' --kernel-dir ' . ale#Escape(g:ast_kernel_dir)
    \   . ' module --gendb'
    \   . ' --output ' . l:tmpoutputdb
    \   . ' -- ' . ale#Escape(fnamemodify(bufname(a:buffer), ':p'))


    " get the content of psy_psyko_jsonconf, and append it to the command line,
    " if provided
    let l:jsonconf = ale#Var(a:buffer, 'psy_psyko_jsonconf')
    if !empty(l:jsonconf)
        if type(l:jsonconf) == v:t_list
            for l:jsonfile in l:jsonconf
                let s:cmdline = s:cmdline . ' ' . ale#Escape(l:jsonfile)
            endfor
        elseif type(l:jsonconf) == v:t_string
            let s:cmdline = s:cmdline . ' ' . l:jsonconf
        endif
    endif

    return s:cmdline
endfunction


" Callback that parses the output of psyko, and returns the error messages to be
" displayed by ALE.
function! s:HandleOutput(buffer, lines) abort
    let l:output = []

    " try to find out errors from GCC preprocessor
    call extend(l:output, ale#handlers#gcc#HandleGCCFormat(a:buffer, a:lines))

    " now look for error specifically issued by psyko
    for l:match in ale#util#GetMatches(a:lines, s:psyko_error_regex)
        " ignore the root error messages that just says 'compilation failed'
        if match(l:match[7], s:psyko_root_error_msg_regex) != -1
            continue
        endif

        call add(l:output, {
                    \   'lnum': l:match[5] + 0,
                    \   'col': l:match[6] + 0,
                    \   'text': l:match[7],
                    \   'detail': l:match[2] . ': ' . l:match[7],
                    \   'code': l:match[2],
                    \   'type': s:psyko_log_msglevel[l:match[1]],
                    \})
    endfor

    return l:output
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Definition of the PsyC linter using psyko
call ale#linter#Define('psy', {
\   'name': 'psyko',
\   'output_stream': 'stderr',
\   'lint_file': 1,
\   'executable': g:ast_psyko_path,
\   'command': function('s:GetCommand'),
\   'callback': function('s:HandleOutput'),
\})

