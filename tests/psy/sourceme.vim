" Description: Source this to define `psy_psyko_jsonconf`. Linting of
"              wrong-syntax.psy should succeed with no error reported


let s:here_dir = expand('<sfile>:p:h')
let g:ale_psy_psyko_jsonconf = s:here_dir . '/flags.psymodule.json'
