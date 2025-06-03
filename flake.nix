{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    packages.aarch64-darwin = {
      # Set the default package to the wrapped instance of Neovim.
      # This will allow running your Neovim configuration with
      # `nix run` and in addition, sharing your configuration with
      # other users in case your repository is public.
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            {
              config.vim = {
                # Enable custom theming options
                theme = {
                  enable = true;
                  name = "gruvbox";
                  style = "dark";
                };

                # Enable Treesitter
                treesitter.enable = true;
                treesitter.mappings = {
                  incrementalSelection.init = "<CR>";
                  incrementalSelection.incrementByScope = "<CR>";
                  incrementalSelection.incrementByNode = "<TAB>";
                  incrementalSelection.decrementByNode = "<S-TAB>";
                };

                filetree.neo-tree.enable = true; 

                languages = {
                  enableFormat = true;
                  enableTreesitter = true;

                  lua = {
                    enable = true;
                    lsp.enable = true;
                  };
                  markdown = {
                    enable = true;
                    lsp.enable = true;
                    extensions.render-markdown-nvim.enable = true;
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

                terminal.toggleterm = {
                  enable = true;
                  lazygit.enable = true;
                };

                binds.whichKey.enable = true;

                telescope.enable = true;

                mini.statusline.enable = true;
                mini.tabline.enable = true;
              };
            }
          ];
        })
        .neovim;
    };
  };
}
