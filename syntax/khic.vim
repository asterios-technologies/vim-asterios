" Vim syntax file
" Language:     KhiC
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.khic
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18

if exists('b:current_syntax')
  finish
endif

" .khic syntax is based on C. So we first request the help of the highly likely
" to already exist C syntax
exe 'runtime! syntax/c.vim'
unlet! b:current_syntax

syn keyword khicStatement prepare count dataaddr datasize datanext datainfo publish with before after on clockperiod clockoffset empty presenttime
syn keyword khicType      worker job output input internal init starttime uses source clock port timebudget duration jitter

" Khic provides the $$#include syntax to include C sources from the KhiC
syn match khicCInclude display "^\s*\$\$#include\>\s*["<]" contains=cIncluded

hi def link khicCInclude        Include
hi def link khicStatement	Statement
hi def link khicType		Type

let b:current_syntax = "khic"
