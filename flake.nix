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
                theme.enable = true;

                # Enable Treesitter
                treesitter.enable = true;

                filetree.neo-tree.enable = true; 
              };
            }
          ];
        })
        .neovim;
    };
  };
}
