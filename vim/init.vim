" Disable polygot packages that use other plugins
let g:polyglot_disabled = ['go', 'rust', 'ruby', 'javascript', 'json', 'html', 'jsx', 'scss', 'typescript', 'vue', 'markdown']

" :PlugInstall
call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'vimlab/split-term.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'Yggdroot/indentLine'
Plug 'bronson/vim-trailing-whitespace'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'dyng/ctrlsf.vim'
Plug 'KabbAmine/vCoolor.vim'
Plug 'henrik/vim-indexed-search'
Plug 'wesQ3/vim-windowswap'
Plug 'alvan/vim-closetag'
Plug 'Shougo/echodoc.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'mattboehm/vim-unstack'
Plug 'qpkorr/vim-bufkill'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Syntaxes
Plug 'fatih/vim-go', { 'for': 'go',  'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim', { 'for' : 'rust' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html'] }
Plug 'maxmellon/vim-jsx-pretty', { 'for': 'jsx' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'HerringtonDarkholme/yats.vim', { 'for': 'typescript' }
Plug 'posva/vim-vue', {'for': 'vue'}
Plug 'gabrielelana/vim-markdown', {'for':'markdown'}
Plug 'jparise/vim-graphql', {'for':'gql'} " This may be wrong
Plug 'sheerun/vim-polyglot'

" Autocomplete
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" Themes
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'less', 'html', 'jsx', 'vue']}

" Post plugins
Plug 'ryanoasis/vim-devicons'
call plug#end()


" Window split settings
highlight TermCursor ctermfg=red guifg=red
set splitbelow
set splitright

" Editor
set hid               " This did something that makes terminal buffers fast
set ruler             " Show the line and column number of the cursor position, separated by a comma
set number            " show line numbers
set wrap              " Wrap long line, don't break words
set linebreak
set nolist
set textwidth=120     " max text width (will force new line)
set cursorline        " highlight current line
set lazyredraw
set showmode          " show the current mode
set showcmd           " show last command
" set scrolloff=5       " start scolling lines 5 from top or bottom
set showmatch         " Highlight matching bracket when cursor is on one of them
set showtabline=2     " Always show tabline
set autoread          " Read file changes from disk
set mouse=a           " Mouse text hightlighting

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent

set hidden           " Don't nag about unwritten changes
set noswapfile       " Disable another annoying message. Don't forget to save your work often!
set noshowmode       " Mode is already visible in airline."

" Searchng
set incsearch         " search as characters are entered
set hlsearch          " highligh search results
set smartcase         " smart casing search
set ignorecase        " Ignore case when searching ...

" Undo
set wildignore+=*/tmp/*
set undodir=~/.vim/tmp
set undofile
set undolevels=1000
set undoreload=10000

set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

if has('clipboard')     " If the feature is available
  set clipboard=unnamed " copy to the system clipboard

  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Or if you have Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" Preset syntaxes
autocmd BufNewFile,BufRead *.marko set filetype=marko.html

" Closing tags
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.tsx,*.vue'

" CTRLSF
let g:ctrlsf_ackprg = 'rg'
let g:ctrlsf_auto_focus = {
  \ 'at': 'start'
  \ }"

" Linter
let g:ale_fix_on_save = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_sql_pgformatter_options = '-U 2 -u 2 -s 2'
let g:ale_fixers = {'typescript': ['eslint'], 'javascript': ['eslint'], 'scss': ['stylelint'], 'sql': ['pgformatter'], 'vue': ['eslint', 'stylelint'], 'terraform': ['terraform'], 'nix': ['nixpkgs-fmt']}
let g:ale_linters = {'javascript': ['eslint'], 'scss': ['stylelint'], 'typescript': ['eslint'], 'vue': ['eslint', 'stylelint']}
let g:ale_linter_aliases = {'vue': ['vue', 'typescript', 'scss']}

" Echodot"
let g:echodoc#enable_at_startup = 1

" Lang Configs
let g:deoplete#enable_at_startup = 1
" inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>""

" Javascript + Frameworks
let g:vue_disable_pre_processors=1
" Weird hack to get typescript autocomplete to load
" autocmd BufRead,BufNewFile *.vue setlocal filetype=typescript
" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.typescript.css.scss

" Json
let g:vim_json_syntax_conceal = 0

" Go
let g:go_metalinter_command='golangci-lint'
let g:go_fmt_command = 'goimports'
let g:go_fmt_options = { 'goimports': '-local github.com/Flatbook/sonder-cli' }
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_metalinter_autosave = 1
let g:go_jump_to_error = 0
" let g:go_metalinter_autosave_enabled = ['vet', 'golint', 'goconst', 'dupl', 'ineffassign', 'misspell']

" Rust
let b:ale_rust_rls_config = {'rust': {'clippy_preference': 'on'}}
let g:ale_rust_cargo_use_clippy = 1

" Terraform
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'

" Markdown
let g:mkdp_open_to_the_world = 1
autocmd FileType markdown setlocal spell
autocmd FileType gitcommit setlocal spell

" CtrlP
set wildignore+=*/node_modules/*

" Incsearch
let g:incsearch#auto_nohlsearch = 1

" NERDComments
let g:NERDSpaceDelims = 1

" NERDTree
let NERDTreeShowHidden=1
let g:nerdtree_tabs_synchronize_view = 0
let g:nerdtree_tabs_focus_on_files = 1

" Autopair
let g:AutoPairsMultilineClose = 0

" Theme
filetype plugin indent on
syntax enable
silent! colorscheme $THEME_DASH
set background=dark
hi Directory guifg=#66D9EF ctermfg=red
hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=none
let g:airline_theme=$THEME
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0

" Terminal
let g:terminal_scrollback_buffer_size = 1000000
let mapleader="\<SPACE>" " Map the leader key to SPACE

" Copy to clipboard
" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X>     "+x
vnoremap <S-Del>   "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C>       "+y
vnoremap <C-Insert>  "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>	"+gP
map <S-Insert> "+gP
vnoremap <C-V> "_dP
vnoremap <S-Insert>	"_dP
" TODO This may be why my paste is weird, or the above is wrong.
imap <C-v> <C-r><C-o>+
" cmap <C-V>		<C-R>
" cmap <S-Insert>		<C-R>+

" Delete
nnoremap d "_d
vnoremap d "_d

" Tab Management
function! ExpandBuffer()
  let ln = line(".")
  tabnew %
  execute ":" . ln
endfunction
function! CollapseBuffer()
  let ln = line(".")
  tabclose
  execute ":" . ln
endfunction
map <S-X> :call ExpandBuffer()<CR>
map <S-Z> :call CollapseBuffer()<CR>
map <S-T> :tabnew<CR>
map <S-H> :tabp<CR>
map <S-L> :tabn<CR>
map <S-W> :bw!<CR>
map <Leader><S-W> :BW<CR>
map <Leader><S-H> :BB<CR>
map <Leader><S-L> :BF<CR>

" Window management
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
if has('nvim')
  nmap <BS> <C-W>h
endif

" Terminal Management
tnoremap <Esc> <C-\><C-n>
map <Leader>[ :Term<CR>
map <Leader>] :VTerm<CR>
map <Leader>\ :term<CR>

" Buffer Management"
" TODO This does not work
" map <C-S-H> :bp<CR>
" map <C-S-L> :bn<CR>

" NERD
map \ :NERDTreeTabsToggle<CR>

" EasyMotion
map <Leader>f <Plug>(easymotion-bd-f)

" Incsearch
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)

" NERDCommenter
map <Leader>/ <Plug>NERDCommenterToggle

" CtrlSF
map <C-S> <Plug>CtrlSFPrompt

" FZF
map <C-P> :FZF<CR>
let g:fzf_preview_window = []
let g:fzf_layout = { 'down': '40%' }

" Doc key bindings
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Custom Commands
command PrettyJson :%!jq .
command PrettyXml :%!python -c 'import sys;import xml.dom.minidom;s=sys.stdin.read();print xml.dom.minidom.parseString(s).toprettyxml()'
command MinifyJson :%!jq -r -c .
command MinifyXml :%!minify --type=xml
command Sudow :w !sudo tee %

" Temp fix?
let g:graphql_javascript_tags = []
