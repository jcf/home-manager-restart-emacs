{
  config,
  pkgs,
  ...
}: {
  programs.emacs = {
    enable = true;

    package = pkgs.emacs-unstable-pgtk;

    extraPackages = epkgs: [epkgs.vterm];

    overrides = final: prev: {
      # `emacs-28` patches are compatible with `emacs-29`.
      #
      # Where a compatible path exists, there is a symlink upstream to keep
      # things clean, but GitHub doesn't follow symlinks to generate the
      # responses we need (instead GitHub returns the target of the symlink).
      patches =
        (prev.patches or [])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            sha256 = "0c41rgpi19vr9ai740g09lka3nkjk48ppqyqdnncjrkfgvm2710z";
          })
          # Use poll instead of select to get file descriptors
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
            sha256 = "0j26n6yma4n5wh4klikza6bjnzrmz6zihgcsdx36pn3vbfnaqbh5";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
            sha256 = "0x187xvjakm2730d1wcqbz2sny07238mabh5d97fah4qal7zhlbl";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
            sha256 = "14ndp2fqqc95s70fwhpxq58y8qqj4gzvvffp77snm2xk76c1bvnn";
          })
        ];
    };
  };
}
