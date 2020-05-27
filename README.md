# vim-asterios

![reviewdog](https://github.com/krono-safe/vim-asterios/workflows/reviewdog/badge.svg)

This repository contains [ViM][1] and [NeoViM][2] support for the following
languages used when developing an [Asterios Application][3]:

* the PsyC (support of the `.psy` files);
* the KhiC (support of the `.khic` files);
* the Bgt (support of the `.bgt` files);
* the tak (support of the `.tak` files).

## Installation

Use your favorite package manager to install this plug-in. We advise to use
[vim-plug][4]. Add the following to your vim configuration file:

```vimrc
Plug 'krono-safe/vim-asterios'
```

and then, after re-launching ViM, run:

```vimrc
:PlugInstall
```


## Contributing

Please refer to the file [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This repository is under the [Apache-V2 license](LICENSE).


[1]: https://www.vim.org/
[2]: https://neovim.io/
[3]: http://www.krono-safe.com/
[4]: https://github.com/junegunn/vim-plug
