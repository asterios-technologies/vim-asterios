" Vim filetype plugin
" Language:     Psy
" Maintainer:   jean.guyomarch@krono-safe.com
" See:          http://www.krono-safe.com/asterios-developer/
" Version:      This is compatible with Asterios Developer K18, K19

if exists('b:did_ftplugin')
  finish
endif

" Psy is built on top of C. Let source first the ftplugin files associated
" with the C language.
runtime! ftplugin/c.vim ftplugin/c_*.vim ftplugin/c/*.vim

let b:did_ftplugin = 1
