" Description: Integration with ALE to run psyko as a linter
" Version: Compatible with ASTERIOS Developer K19.2

call ale#Set('psy_psyko_executable', 'psyko')
call ale#Set('psy_psyko_product', 'ksim')
call ale#Set('psy_psyko_kernel_dir', '')
call ale#Set('psy_psyko_options', '--color no')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:psyko_error_regex =
            \ '\v\w+\>(fatal|error|warning)\>' .
            \ '\s+(\w+):\s+((.*):(\d+):(\d+):\s+)?(.*)$'

let s:psyko_log_msglevel = {
                    \ 'fatal': 'E',
                    \ 'error': 'E',
                    \ 'warning': 'W',
                    \ '': 'E'
                    \}

let s:psyko_root_error_msg_regex = '\v\(faulty command below\):'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:GetExecutable(buffer) abort
    let l:exec = ale#Var(a:buffer, 'psy_psyko_executable')

    " TODO: handle gracefuly error cases:
    "
    "   - incorrect psyko version
    "   - psy_psyko_kernel_dir doesn't exist

    return l:exec
endfunction


function! s:GetCommand(buffer) abort
    " prepare a temp file for the output db
    let l:tmpoutputdb = tempname() . '.ks'
    call ale#command#ManageFile(a:buffer, l:tmpoutputdb)

    return '%e '
    \   . ale#Var(a:buffer, 'psy_psyko_options')
    \   . ' --product ' . ale#Var(a:buffer, 'psy_psyko_product')
    \   . ' --kernel-dir ' . ale#Var(a:buffer, 'psy_psyko_kernel_dir')
    \   . ' module --gendb'
    \   . ' --output ' . l:tmpoutputdb
    \   . ' -- ' . ale#Escape(fnamemodify(bufname(a:buffer), ':p'))
endfunction


function! s:HandleOutput(buffer, lines) abort
    let l:output = []

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

call ale#linter#Define('psy', {
\   'name': 'psyko',
\   'output_stream': 'stderr',
\   'lint_file': 1,
\   'executable': function('s:GetExecutable'),
\   'command': function('s:GetCommand'),
\   'callback': function('s:HandleOutput'),
\})

