{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ]
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            {
              config.vim = {
                undoFile.enable = true;
                searchCase = "smart";
                hideSearchHighlight = true;

                options.clipboard = "unnamedplus";
                theme = {
                  enable = true;
                  name = "oxocarbon";
                  style = "dark";
                };

                extraPlugins = with pkgs.vimPlugins; {
                  vim-tmux-navigator = {
                    package = vim-tmux-navigator;
                  };
                  better-escape-nvim = {
                    package = better-escape-nvim;
                    setup = ''
                      require("better_escape").setup({
                        timeout = 300;
                        default_mappings = true;
                      });
                    '';
                  };
                };

                keymaps = [
                  ##################################################
                  # Normal Mode Keymaps
                  ##################################################
                  {
                    mode = "n";
                    key = "<leader>o";
                    action = ":Neotree focus<CR>";
                    desc = "Focus Neo-tree";
                  }

                  {
                    mode = "n";
                    key = "<leader>e";
                    action = ":Neotree toggle<CR>";
                    desc = "Toggle Neo-tree";
                  }

                  {
                    mode = "n";
                    key = "<Leader>q";
                    action = ":q<CR>";
                    desc = "Quit";
                  }

                  {
                    mode = "n";
                    key = "<Leader>Q";
                    action = ":qa<CR>";
                    desc = "Quit All";
                  }

                  {
                    mode = "n";
                    key = "<Leader>w";
                    action = ":w<CR>";
                    desc = "Save";
                  }

                  {
                    mode = "n";
                    key = "<Leader>W";
                    action = ":wa<CR>";
                    desc = "Save All";
                  }

                  {
                    mode = "n";
                    key = "<Leader>lc";
                    action = ":Copilot! attach<CR>";
                    desc = "Copilot attach";
                  }

                  # Leaving "action" empty just adds a WhichKey entry with a label
                  {
                    mode = "n";
                    key = "<Leader>t";
                    action = "";
                    desc = "ToggleTerm";
                  }

                  {
                    mode = "n";
                    key = "<Leader>tf";
                    action = ":ToggleTerm direction=float<CR>";
                    desc = "Floating terminal";
                  }

                  {
                    mode = "n";
                    key = "<Leader>th";
                    action = ":ToggleTerm direction=horizontal<CR>";
                    desc = "Horizontal terminal";
                  }

                  {
                    mode = "n";
                    key = "<Leader>tv";
                    action = ":ToggleTerm direction=vertical<CR>";
                    desc = "Vertical terminal";
                  }

                  {
                    mode = "n";
                    key = "|";
                    action = ":vsplit<CR>";
                    desc = "Split window vertically";
                  }

                  {
                    mode = "n";
                    key = "\\";
                    action = ":split<CR>";
                    desc = "Split window horizontally";
                  }

                  ##################################################
                  # Insert Mode Keymaps
                  ##################################################
                  {
                    mode = "i";
                    key = "<C-i>";
                    action = "<C-o>o";
                    desc = "Continue on next line";
                  }

                  ##################################################
                  # Terminal Mode Keymaps
                  ##################################################
                  # {
                  #   mode = "t";
                  #   key = "<Esc>";
                  #   action = "<C-\\><C-n>";
                  #   desc = "Exit terminal mode";
                  # }
                ];

                ##################################################
                # Plugin configuration
                ##################################################
                utility.surround = {
                  enable = true;
                  setupOpts.keymaps = {
                    insert = "<C-g>s";
                    insert_line = "<C-g>S";
                    normal = "ys";
                    normal_cur = "yss";
                    normal_line = "yS";
                    normal_cur_line = "ySS";
                    visual = "S";
                    visual_line = "gS";
                    delete = "ds";
                    change = "cs";
                    change_line = "cS";
                  };
                };

                treesitter = {
                  enable = true;
                  indent.enable = false;
                  mappings = {
                    incrementalSelection.init = "<CR>";
                    incrementalSelection.incrementByScope = "<CR>";
                    incrementalSelection.incrementByNode = "<TAB>";
                    incrementalSelection.decrementByNode = "<S-TAB>";
                  };
                };

                filetree.neo-tree = {
                  enable = true;
                  setupOpts = {
                    close_if_last_window = true;
                  };
                };

                terminal.toggleterm = {
                  enable = true;
                  lazygit.enable = true;
                };

                git.gitsigns = {
                  enable = true;
                  codeActions.enable = true;
                };

                tabline.nvimBufferline = {
                  enable = true;
                  mappings = {
                    closeCurrent = "<leader>c";
                  };
                };

                binds.whichKey.enable = true;

                telescope.enable = true;

                statusline.lualine.enable = true;

                autocomplete.blink-cmp.enable = true;

                assistant.copilot.enable = true;

                autopairs.nvim-autopairs.enable = true;
                notes.todo-comments.enable = true;

                comments.comment-nvim = {
                  enable = true;
                  mappings = {
                    toggleSelectedBlock = "<Leader>/";
                    toggleSelectedLine = "<Leader>/";
                    toggleCurrentLine = "<Leader>/";
                  };
                };

                ui.noice = {
                  enable = true;
                };

                ##################################################
                # Language support
                ##################################################
                languages = {
                  enableFormat = true;
                  enableTreesitter = true;

                  bash = {
                    enable = true;
                    lsp.enable = true;
                    extraDiagnostics.enable = true;
                  };
                  lua = {
                    enable = true;
                    lsp.enable = true;
                  };
                  markdown = {
                    enable = true;
                    lsp.enable = true;
                    extensions.render-markdown-nvim.enable = true;
                  };
                  nu = {
                    enable = true;
                    lsp.enable = true;
                  };
                  nix = {
                    enable = true;
                    lsp.enable = true;
                  };
                  python = {
                    enable = true;
                    lsp.enable = true;
                  };
                  rust = {
                    enable = true;
                    crates.enable = true;
                    lsp.enable = true;
                  };
                  yaml = {
                    enable = true;
                    lsp.enable = true;
                  };
                };
              };
            }
          ];
        })
        .neovim;
    });
}
