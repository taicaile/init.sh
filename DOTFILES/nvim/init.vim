

"""" Basic Behavior
set number              " show line  numbers
set wrap                " warp lines
set encoding=utf-8      " default encoding setting
set mouse=a             " enable mouse support
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw screen only when we need to
set showmatch           " highlight matching parentheses / brackets [{()}]
set laststatus=2        " always show statusline (even with only single window)
set ruler               " show line and column number of the cursor on right side of statusline
set visualbell          " blink cursor on error, instead of beeping

set cursorline          " highlight current line

"""" Tab Setting
set tabstop=4           " width that a <TAB> character displays as
set expandtab           " convert <TAB> key-presses to spaces
set shiftwidth=4        " number of spaces to use for each step of (auto)indent
set softtabstop=4       " backspace after pressing <TAB> will remove up to this many spaces

set autoindent          " copy indent from current line when starting a new line
set smartindent         " even better autoindent (e.g. add indent after '{')


"""" Appearance
colorscheme murphy
filetype plugin indent on
syntax on

"""" Search settings

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

"""" Auto Read
set autoread
