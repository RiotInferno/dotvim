call pathogen#infect()

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

set backspace=indent,eol,start

if match( $TERM, "screen" )!=-1
   set term=xterm
endif

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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

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
nmap <F5> :%s/\s\+$//<CR>
nmap <F6> :call JCommentWriter()<CR>
nnoremap <F7> :Dispatch<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F9> :CtrlP<CR>
nmap <F12> :exec ParseNewCode()<CR>

" Syntastic Setings
" let g:syntastic_cpp_check_header = 0
let g:syntastic_cpp_remove_include_errors = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_compiler_options = ' -g -O0 -Werror -Wall -D_DEBUG -rdynamic'

let g:syntastic_cpp_include_dirs = [ '/home/johna/CSF/trunk/sw/src/libcsf/include',
                                   \ '/home/johna/TechKits/xptools/core/include',
                                   \ '/home/johna/TechKits/xptools/core/build/include',
                                   \ '/home/johna/CSF/trunk/sw/utils/controlbus',
                                   \ '/home/johna/CSF/trunk/sw/utils/csfproduct',
                                   \ '/home/johna/CSF/trunk/sw/csp_sdk/include' ]

" VCS Settings
nmap [23~ :VCSVimDiff<CR>
nmap [24~ :VCSUpdate<CR>
nmap [25~ :VCSAdd<CR>
nmap [26~ :VCSDelete<CR>
nmap [28~ :VCSCommit<CR>
