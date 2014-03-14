call pathogen#infect()
nmap <F8> :TagbarToggle<CR>
syntax on
filetype indent on
set autoindent
set nu
set ic
set hls
set lbr
set tabstop=3
set shiftwidth=3
set expandtab

"highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
"match OverLength /\%>80v.\+/
match ErrorMsg '\%>80v.\+'

"set tags=./tags
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
     set t_Co=256
  endif

if v:version >= 600
   filetype plugin on
   filetype indent on
else
   filetype on
endif

if v:version >= 700
   set omnifunc=syntaxcomplete#Complete " override built-in C omnicomplete with C++ OmniCppComplete plugin
   let OmniCpp_GlobalScopeSearch   = 1
   let OmniCpp_DisplayMode         = 1
   let OmniCpp_ShowScopeInAbbr     = 0 "do not show namespace in pop-up
   let OmniCpp_ShowPrototypeInAbbr = 1 "show prototype in pop-up
   let OmniCpp_ShowAccess          = 1 "show access in pop-up
   let OmniCpp_SelectFirstItem     = 1 "select first item in pop-up
   set completeopt=menuone,menu,longest
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
map <F2> :NERDTreeToggle<CR>
map <F3> :TlistToggle<CR>
map <Esc>[D :tabprevious<CR>
map <Esc>[C :tabnext<CR>
map <F9> :!scons server<CR>
map <F10> :!scons webclient<CR>
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

map <F12> :exec ParseNewCode()

inoremap <Tab> <C-R>=SuperCleverTab()<cr>

"autocmd VimEnter * NERDTree

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

:nmap ; :CtrlPBuffer<CR>
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

map <F4> :call ConvertLineEndings()<CR> 
map <F6> :call JCommentWriter()<CR>

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_quiet_warnings=1

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

:function! FixCommas()
   :! perl $s=join(qq{\n},$curbuf->Get(0 .. $curbuf->Count()));$s =~ s#^((?:[^/\n]|/(?!/))*),((?:\s*|//.*$|/\*(?:[^*]|\*(?!/))*\*/)*\s*[}\]])#$1$2#mg; $curbuf->Set(0,0,split(qq{\n},$s));
endfunction

map <F11> :call FixCommas()<CR> 

autocmd FileType cpp let b:dispatch = 'scons -u'
nnoremap <F7> :Dispatch<CR>

