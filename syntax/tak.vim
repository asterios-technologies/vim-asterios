" Vim syntax file
" Language:     Tak
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.tak
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18

if exists('b:current_syntax')
  finish
endif

set iskeyword+=@-@

syn keyword     takTodo contained TODO FIXME XXX
syn keyword     takDirective @include @const @default @tag .std.unused
syn keyword     takDirective .std.empty .std.none

syn match takTag        "<.*>"ms=s+1,me=e-1  contained
syn match takSection    "^\..*" contains=takTag
syn match takInstan     "^\!.*" contains=takTag
syn match takIdentifier "^.\{-\}="ms=s+1,me=e-1
syn match takIdentifier "^.\{-\}[+|,]="ms=s+1,me=e-2
syn match takIdentifier "^\s*\<.\{-\}\>"

syn match       takComment      "^#.*" contains=takTodo
syn match       takComment      "\s*#.*"ms=s+1 contains=takTodo

syn region      takString       start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region      takString       start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline

hi def link takComment    Comment
hi def link takTodo       Todo
hi def link takString     String
hi def link takSection    Keyword
hi def link takInstan     Keyword
hi def link takTag        Type
hi def link takDirective  Special
hi def link takIdentifier Identifier

let b:current_syntax = 'tak'
