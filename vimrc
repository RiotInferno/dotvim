set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle
call vundle#rc()

Plugin 'gmarik/vundle'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
"Plugin 'vim-scripts/genutils'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
"Plugin 'scrooloose/syntastic'
Plugin 'majutsushi/tagbar'
"Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/vim-powerline'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'


func! vundle#end(...) abort
   if (exists("g:vundle_lazy_load"))
      unlet g:vundle_lazy_load
   endif
   call vundle#config#activate_bundles()
endf

call vundle#end()

syntax on
set clipboard=unnamed
set number

filetype plugin indent on
set autoindent
set nu
set ic
set hls
set lbr
set tabstop=3
set shiftwidth=3
set expandtab

set backspace=indent,eol,start

if match( $TERM, "screen" )!=-1
   set term=xterm
endif

"highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
"match OverLength /\%>80v.\+/
match ErrorMsg '\%>80v.\+'

"set tags=./tags
"if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
"     set t_Co=256
"endif
set t_Co=256


if v:version >= 600
   filetype plugin on
   filetype indent on
else
   filetype on
endif

if version >= 700
   let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
   highlight   clear
   highlight   Pmenu         ctermfg=0 ctermbg=2
   highlight   PmenuSel      ctermfg=0 ctermbg=7
   highlight   PmenuSbar     ctermfg=7 ctermbg=0
   highlight   PmenuThumb    ctermfg=0 ctermbg=7
endif

"colorscheme desert
colorscheme twilight
highlight Pmenu ctermbg=238 gui=bold
let g:NERDTreeDirArrows=0
map <Esc>[D :tabprevious<CR>
map <Esc>[C :tabnext<CR>
imap ii <Esc>

function! SuperCleverTab()
   if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
      return "\<Tab>"
   else
      if &omnifunc != ''
         return "\<C-X>\<C-O>"
      elseif &dictionary != ''
         return "\<C-K>"
      else
         return "\<C-N>"
      endif
   endif
endfunction

function! ParseNewCode()
   :!~/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --languages=C++ --if0=yes .
   :!find . -iname "*.cpp" -o -iname "*.c" -o -iname "*.h" > ./cscope.files
   :!cscope -b -q -k
endfunction

function! StyleFormatter()
   :%!astyle
   :%s#\($\n\s*\)\+\%$##
   :%s/\s\+$//e
   :%s/\[ \(.*\) \]/\[\1\]/ge
endfunction

inoremap <Tab> <C-R>=SuperCleverTab()<cr>

"autocmd VimEnter * NERDTree

"autocmd BufEnter * nested :call tagbar#autoopen(1)

"CScope stuff
set cscopetag
set csto=0

cs add ./cscope.out

set cscopeverbose

nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

set runtimepath^=~/.vim/bundle/ctrlp.vim

"search stuff
:set incsearch
:set ignorecase
:set smartcase
:set hlsearch
:nmap \q :nohlsearch<CR>

:let g:ctrlp_map = '<Leader>t'
:let g:ctrlp_match_window_bottom = 0
:let g:ctrlp_match_window_reversed = 0
:let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
:let g:ctrlp_working_path_mode = 0
:let g:ctrlp_dotfiles = 0
:let g:ctrlp_switch_buffer = 0

function! ConvertLineEndings()
   :update
   :e ++ff=dos
   :setlocal ff=unix
   :w
endfunction

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

function! NeatFoldText() "{{{2
   let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
   let lines_count = v:foldend - v:foldstart + 1
   let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
   let foldchar = split(filter(split(&fillchars, ','), 'v:val =~# "fold"')[0], ':')[-1]
   let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
   let foldtextend = lines_count_text . repeat(foldchar, 8)
   let length = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g'))
   return foldtextstart . repeat(foldchar, winwidth(0)-length) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}2

set foldmethod=syntax

autocmd FileType cpp let b:dispatch = 'scons -u'

nmap <F1> :CtrlPBuffer<CR>
nmap <F2> :NERDTreeToggle<CR>
nmap <F3> :TagbarToggle<CR>
nmap <F4> :call ConvertLineEndings()<CR>
" nmap <F5> :%s/\s\+$//<CR> :%s/\[ \(.*\) \]/\[\1\]/g<CR> :%!astyle<CR>
nmap <F5> :exec StyleFormatter()<CR> 
nmap <F6> :call JCommentWriter()<CR>
nnoremap <F7> :Dispatch<CR>
" Find comments and make sure there's a space
nmap <F8> :%s!\v//(\w)!// \1!g<CR> 
nmap <F9> :CtrlP<CR>
nmap <F12> :exec ParseNewCode()<CR>

" Syntastic Setings
"let g:syntastic_cpp_check_header = 1
"let g:syntastic_cpp_remove_include_errors = 1
"let g:syntastic_enable_signs = 1
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_cpp_compiler_options = ' -g -O0 -Werror -Wall -D_DEBUG -rdynamic'

"let g:syntastic_cpp_include_dirs = [ '/home/johna/CSF/trunk/sw/src/libcsf/include',
"                                   \ '/home/johna/TechKits/xptools/core/include',
"                                   \ '/home/johna/TechKits/xptools/core/build/include',
"                                   \ '/home/johna/CSF/trunk/sw/utils/controlbus',
"                                   \ '/home/johna/CSF/trunk/sw/utils/csfproduct',
"                                   \ '/home/johna/CSF/trunk/sw/csp_sdk/include' ]

let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"



" Notes:
"   (1) To enhance the ergonomics of this sufficiently to make it practical, at
"       least, until your brain grows a new lobe dedicated to counting line offsets
"       in the background while you work, you should either make sure you have
"       something like the following in your `~/.vimrc`:
"
           set number
           if has('autocmd')
           augroup vimrc_linenumbering
               autocmd!
               autocmd WinLeave *
                           \ if &number |
                           \   set norelativenumber |
                           \ endif
               autocmd BufWinEnter *
                           \ if &number |
                           \   set relativenumber |
                           \ endif
               autocmd VimEnter *
                           \ if &number |
                           \   set relativenumber |
                           \ endif
           augroup END
           endif
"
"       or you have installed a plugin like
"       (vim-numbers)[https://github.com/myusuf3/numbers.vim].
"
"   (2) You might want to relax the constraint for horizontal motions, or
"       add other motions. You can customize the list of motions by
"       specifying the keys in the
"       `g:keys_to_disable_if_not_preceded_by_count` variable. For example,
"       the following only enforces count-prefixed motions for "j" and "k":
"
"         let g:keys_to_disable_if_not_preceded_by_count = ["j", "k"]

function! DisableIfNonCounted(move) range
    if v:count
        return a:move
    else
        " You can make this do something annoying like:
           " echoerr "Count required!"
           " sleep 2
        return ""
    endif
endfunction

function! SetDisablingOfBasicMotionsIfNonCounted(on)
    let keys_to_disable = get(g:, "keys_to_disable_if_not_preceded_by_count", ["j", "k", "l", "h", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"])
    if a:on
        for key in keys_to_disable
            execute "noremap <expr> <silent> " . key . " DisableIfNonCounted('" . key . "')"
        endfor
        let g:keys_to_disable_if_not_preceded_by_count = keys_to_disable
        let g:is_non_counted_basic_motions_disabled = 1
    else
        for key in keys_to_disable
            try
                execute "unmap " . key
            catch /E31:/
            endtry
        endfor
        let g:is_non_counted_basic_motions_disabled = 0
    endif
endfunction

function! ToggleDisablingOfBasicMotionsIfNonCounted()
    let is_disabled = get(g:, "is_non_counted_basic_motions_disabled", 0)
    if is_disabled
        call SetDisablingOfBasicMotionsIfNonCounted(0)
    else
        call SetDisablingOfBasicMotionsIfNonCounted(1)
    endif
endfunction

command! ToggleDisablingOfNonCountedBasicMotions :call ToggleDisablingOfBasicMotionsIfNonCounted()
command! DisableNonCountedBasicMotions :call SetDisablingOfBasicMotionsIfNonCounted(1)
command! EnableNonCountedBasicMotions :call SetDisablingOfBasicMotionsIfNonCounted(0)

DisableNonCountedBasicMotions

inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>
