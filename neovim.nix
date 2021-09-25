{ package, plugins }:
{
  enable = true;
  vimAlias = true;
  viAlias = true;
  package = package;

  plugins = with plugins; [
    airline
    nord-vim
    nvim-lspconfig
    nvim-treesitter
    rust-tools-nvim
    vim-nix
    completion-nvim
  ];
  
  extraConfig = ''
      syntax on
      filetype off
      filetype plugin indent on
      set expandtab
      set tabstop=2
      set softtabstop=0
      set shiftwidth=2
      set smarttab
      set autoindent
      set smartindent
      set smartcase
      set ignorecase
      set modeline
      set nocompatible
      set encoding=utf-8
      set incsearch
      set hlsearch
      set history=700
      set number
      set laststatus=2
      set signcolumn=yes
      set termguicolors
      set background=dark
      colorscheme nord

      let g:airline_theme = 'nord'
      let g:airline_powerline_fonts = 1

      " Use completion-nvim in every buffer
      autocmd BufEnter * lua require'completion'.on_attach()
      
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
      
      "map <c-space> to manually trigger completion
      
      inoremap <c-space> <c-p>

      inoremap jj <Esc>

      " Set completeopt to have a better completion experience
      set completeopt=menuone,noinsert,noselect

      " Avoid showing message extra message when using completion
      set shortmess+=c

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        ignore_install = {}, -- List of parsers to ignore installing
        highlight = {
          enable = true,              -- false will disable the whole extension
          disable = {},  -- list of language that will be disabled
        },
      }

      vim.lsp.set_log_level("debug")
      require'lspconfig'.rnix.setup{}
      EOF
    '';
}
