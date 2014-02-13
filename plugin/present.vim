" This Source Code Form is subject to the terms of the Mozilla Public
" License, v. 2.0. If a copy of the MPL was not distributed with this
" file, You can obtain one at http://mozilla.org/MPL/2.0/.

" Plugin to use Vim for presentations.
"
" To use, load all the files you want to show (`vim slides*`), then `:Present`.
" User commands:
"   :Present  Turn on presentation mode.  (There is no way to turn it off.)
" In presentation mode:
"   <Space>  Next file
"   <Backspace>  Previous file
" Use Gvim or make sure your terminal emulator's colours are set correctly.  A
" lot of cterms use black/white background but set the Black/White colours to a
" shade of grey.

if exists("g:present_loaded")
    finish
endif
let g:present_loaded = 1

function s:default(name, value)
    if !exists(a:name)
        exe "let" a:name "=" string(a:value)
    endif
endfunction

" Default configuration; override these in your .vimrc:
call s:default("g:present_width", 80)
call s:default("g:present_height", 10)
" Be sure to backslash-escape spaces and single-quote the whole thing.
" This default assumes GTK2-style font specification.  
call s:default("g:present_fontspec", 'Monospace\ 20')


command Present call <SID>PresentOn()

" Create the augroup for commands defined later
augroup present
augroup END

function <SID>PresentOn()
    if has("gui_running")
        call s:SetFont()
        " Hide GUI widgets.  Use your WM to remove client decorations.
        for opt in ["m","T","r","R","l","L","b"]
            exe "set guioptions-=".opt
        endfor
    endif

    set laststatus=0 " No status line for the bottom window.
    
    call s:MakeWindows()
    call s:Resize()
    autocmd present VimResized * call s:Resize()
    call s:SetColours()
    autocmd present QuitPre * call s:OnQuitPre()

    " Always hide modelines.
    autocmd present Syntax * call s:HideModeline()
    set conceallevel=2
    set concealcursor=nc

    " Space/backspace do next/previous (and force the cursor to the start).
    nnoremap <Space> :next! +normal\ gg<CR>
    nnoremap <Backspace> :previous! +normal\ gg<CR>
endfunction

function s:SetFont()
    try
        exe "set guifont=".g:present_fontspec
    catch
        set guifont=*
    endtry
endfunction

function s:MakeWindows()
    leftabove vnew
    setlocal nomodifiable
    wincmd l

    rightbelow vnew
    setlocal nomodifiable
    wincmd h
    
    above new
    setlocal nomodifiable
    wincmd j

    below new
    setlocal nomodifiable
    wincmd k
endfunction

function s:Resize()
    " This is a simple way to centre the middle window and give it a size, but
    " the size is treated as a minimum, so the window will end up at least a
    " third of the screen width in each dimension.
    exe "setlocal winheight=".g:present_height
    exe "setlocal winwidth=".g:present_width
    wincmd =
endfunction

function s:SetColours()
    hi StatusLine ctermbg=Grey ctermfg=DarkGrey
    " Hide visual junk by setting it to the background colour.
    try
        call s:SetHidingColours("bg")
    catch /^Vim\%((\a\+)\)\=:E420/
        " E420: Vim doesn't know what the background colour is.
        if &background == "dark"
            call s:SetHidingColours("Black")
        else
            call s:SetHidingColours("White")
        endif
    endtry
endfunction

function s:SetHidingColours(bg)
    " Assume gvim knows its own background colour.
    exe "hi NonText guifg=bg ctermfg=".a:bg
    exe "hi VertSplit guibg=bg guifg=bg ctermbg=".a:bg "ctermfg=".a:bg
    exe "hi StatusLineNC guibg=bg guifg=bg ctermbg=".a:bg "ctermfg=".a:bg
endfunction

function s:OnQuitPre()
    " Make :q force quit like :qa!  This might be dangerous, but why are you
    " saving edits in presentation mode?  Plus, it matches next! and prev!.
    wincmd o
    silent! argdelete *
    set nomodified
endfunction

function s:HideModeline()
    syntax match Modeline conceal /vim: .*$/
endfunction

