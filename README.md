# vim-present

vim-present is a Vim plugin for using Vim in presentations.  If most of your
supporting material is code, you get syntax highlighting for free!

## Installation

Put `plugin/present.vim` in `~/.vim/plugins`.

## Usage

You can use Vim in the terminal or Gvim.

* Load all the files you want in the argument list: `$ gvim slide*`
* Start presentation mode: `:Present`
* Switch files with space and backspace.

## Configuration

If you're using Vim in a terminal, you have extra work to do:

* Pick a good (big) presentation font.
* Make sure the terminal emulator's colours are set right.

To hide things Vim insists on drawing (like window-separators), vim-present
sets them to be drawn in the background colour.  Some terminals, however, use
pure black or white as the default background but a nearby shade of grey when
Vim asks for black or white.  You may need to adjust the colour scheme.  (In
gnome-terminal, most of the presets work right.)

You can change the size of the display area from your `.vimrc`: 

    let g:present_width = 80
    let g:present_height = 10

If you're using Gvim, you can set the font to use as well (under GTK; other
systems are different...):

    g:present_fontspec = 'Monospace\ 20'

