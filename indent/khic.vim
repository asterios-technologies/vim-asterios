" Vim indent file
" Language:     KhiC
" Maintainer:   Jean Guyomarc'h <jean.guyomarch@krono-safe.com>
" Filenames:    *.khic
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18

if exists('b:did_indent')
  finish
endif

" KhiC is built on top of C. Let source first the indent files associated
" with the C language.
runtime! indent/c.vim

let b:did_indent = 1
