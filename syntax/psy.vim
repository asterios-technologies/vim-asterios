" Vim syntax file
" Language:     Psy
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.psy
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18 and K19

if exists('b:current_syntax')
  finish
endif

" .psy syntax is based on C. So we first request the help of the highly likely
" to already exist C syntax
exe 'runtime! syntax/c.vim'
unlet! b:current_syntax

syn keyword psycStatement sourcedata sourcecommand advance endbody next consult jump count push pop clearlasttimestamp lastsender countpushers clockperiod clockoffset taskid presenttime converttick popperstatus displayerstatus starttime
syn keyword psycKeyword with global display delayed latest waitfor releasein within timebudget popfrom pushto expiration init defaultclock uses starton onclock jitter
syn keyword psycControl body agent worker job output input internal init khibody
syn keyword psycTypeQualifier fractional temporal stream
syn keyword psycType source clock duration t_ast_clock_tick t_ast_source_time t_ast_task_id
syn keyword psycConstant all AST_TASK_STOPPED AST_TASK_RUNNING AST_CLOCK_TICK_NEGATIVE AST_SOURCE_TIME_NEGATIVE

" Psy provides the $$#include syntax to include C sources from the Psy
syn match psycCInclude display "^\s*\$\$#include\>\s*["<]" contains=cIncluded


hi def link psycStatement       Statement
hi def link psycTypeQualifier   StorageClass
hi def link psycType            Type
hi def link psycCInclude        Include
hi def link psycConstant        Constant
hi def link psycKeyword         Statement
hi def link psycControl         Repeat

let b:current_syntax = "psy"
