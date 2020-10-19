# vim-asterios

![reviewdog](https://github.com/krono-safe/vim-asterios/workflows/reviewdog/badge.svg)

This repository contains [ViM][1] and [NeoViM][2] support for the following
languages used when developing an [ASTERIOS Application][3]:

* the PsyC (support of the `.psy` files, provided with [SnipMate][7] compatible
  snippets);
* the KhiC (support of the `.khic` files);
* the Bgt (support of the `.bgt` files);
* the tak (support of the `.tak` files).

It also features an integration with [ALE][5] to provide linting of PsyC source
files.

## Installation

Use your favorite package manager to install this plug-in. [vim-plug][4] is
recommended. Add the following to your vim configuration file:

```vim
Plug 'krono-safe/vim-asterios'
```

and then, after re-launching ViM, run:

```vim
:PlugInstall
```
## PsyC Linting

![Screenshot of a Gvim window showing a syntax error in a PsyC file](https://user-images.githubusercontent.com/8275119/82766994-2d0c1800-9e24-11ea-8b1a-e3a3a96f0582.png)

To enable linting of PsyC source files, you need the [ALE][5] plug-in.
The linting is actually performed by running `psyko module`, thus you need to
provide some configuration for the command to work. For example:

```vimrc
" local variable: root Krono-Safe installation directory
let s:ks_dir = 'C:\Program Files (x86)\Krono-Safe'

" full path to psyko.exe
let g:ast_psyko_path = s:ks_dir . '\psyko-8.10.2\bin\psyko.exe'

" default product is ksim, but you can override this if you want
" (let's not do that here, and leave this line commented out)
" let g:ast_product_name = 'power-mpc5777m-module'

" kernel-dir path (--kernel-dir argument)
let g:ast_kernel_dir = s:ks_dir . '\ksim-8.10.2'
```

For more information, see `:help vim-asterios-psyc-lint`.


## JSON Configuration Files Linting and Autocompletion

![Animated GIF of linting and autocompletion of an ASTERIOS JSON configuration file](https://user-images.githubusercontent.com/8275119/83838786-7ef14f80-a6fa-11ea-82a8-57c34d146f26.gif)

Linting and autocompletion of JSON configuration files requires another
plug-in: [coc.nvim][6]. Once you have installed it, install the JSON language
server extension with:

```vim
:CocInstall coc-json
```

*vim-asterios* is then ready to take care of the rest of the configuration for
you. Make sure that `g:ast_product_name` and `g:ast_kernel_dir` are correctly
set, then run `:AsteriosConfig` in a buffer with your JSON configuration file to
enable linting and autocompletion.

See `:help vim-asterios-json-comp` for more information.


## Contributing

Please refer to the file [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This repository is under the [Apache-V2 license](LICENSE).

[1]: https://www.vim.org/
[2]: https://neovim.io/
[3]: http://www.krono-safe.com/
[4]: https://github.com/junegunn/vim-plug
[5]: https://github.com/dense-analysis/ale
[6]: https://github.com/neoclide/coc.nvim
[7]: https://github.com/garbas/vim-snipmate
