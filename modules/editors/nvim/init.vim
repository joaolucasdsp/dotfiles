set undofile
set noshowmode
set undolevels=1000
set number relativenumber
set expandtab tabstop=2 shiftwidth=2
set cursorline
set termguicolors
set colorcolumn=80
set nofoldenable
set showcmd
set ignorecase smartcase
set textwidth=80
set sessionoptions+=globals
set hidden
set guifont=JetBrains\ Mono:h11
set wildignorecase
set linebreak
set autoindent
set smartindent
set splitright
set scrolloff=5
set lazyredraw
set noswapfile
set nomodeline
set autoread
set completeopt=menuone,noselect
set pumheight=10
set pumwidth=25
set updatetime=400
set iskeyword-=-
set formatoptions-=t
set shortmess+=cI
set winborder=single
set laststatus=3

noremap Y "+y
noremap H ^
noremap L $
nnoremap Q @@
nnoremap <C-p> <C-^>

nnoremap j gj
nnoremap k gk

nnoremap <C-q> <C-w>q

command Cnext try | cnext | catch | cfirst | catch | endtry
command Cprev try | cprev | catch | clast  | catch | endtry
command Lnext try | lnext | catch | lfirst | catch | endtry
command Lprev try | lprev | catch | llast  | catch | endtry

nnoremap [q <cmd>Cprev<cr>
nnoremap ]q <cmd>Cnext<cr>
nnoremap [Q <cmd>cfirst<cr>
nnoremap ]Q <cmd>clast<cr>

nnoremap [w <cmd>Lprev<cr>
nnoremap ]w <cmd>Lnext<cr>
nnoremap [W <cmd>lfirst<cr>
nnoremap ]W <cmd>llast<cr>

nnoremap <leader>to :tabnew<space>
nnoremap <leader>tq :tabclose<cr>
nnoremap <silent>g< :tabmove tabpagenr() - 2<cr>
nnoremap <silent>g> :tabmove tabpagenr() + 1<cr>

nnoremap <silent> <leader>vQ <cmd>quitall!<cr>
nnoremap <silent> <leader>vq <cmd>quitall<cr>
nnoremap <silent> <leader>vr <cmd>source $MYVIMRC<cr>

nnoremap <C-s> :w<cr>

vnoremap . :normal .<cr>

lua vim.filetype.add({ pattern = { ['.*%.component%.html'] = 'htmlangular' } })

augroup my_autocommands
  autocmd!
  au FileType help wincmd L
  au TextYankPost * silent! lua vim.hl.on_yank{timeout=50}

  au BufEnter *.fs,*.fsi set ft=fsharp
  autocmd FileType fsharp setlocal commentstring=//\ %s
augroup end

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &number | setlocal relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter   * if &number | setlocal norelativenumber | endif
augroup end
