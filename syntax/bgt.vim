" Vim syntax file
" Language:     Bgt
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.bgt
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18, K19

if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syn match       bgtComment             /#.*$/
syn keyword     bgtKw                  s ms us ns
syn match       bgtNumber              "\d\+"

hi def link     bgtComment             Comment
hi def link     bgtKw                  Type
hi def link     bgtNumber              Number

let b:current_syntax = 'bgt'
