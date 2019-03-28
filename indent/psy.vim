" Vim indent file
" Language:     Psy
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.psy
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18, K19

if exists('b:did_indent')
  finish
endif

" Psy is built on top of C. Let source first the indent files associated
" with the C language.
runtime! indent/c.vim

let b:did_indent = 1
