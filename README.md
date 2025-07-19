# Dotfiles

This repo contains some configuration files for a small set of basic programs.
The dotfiles are managed with the GNU `stow` command.

This repo also contains a list of packages you will need to install to get your minimal system running.

## List of Packages

You may find a [**list**](./pkg-pacman.txt) of packages you need to install via pacman.

This [**other list**](./pkg-aur.txt) has a list of packages only available from
AUR. Please, use your favorite AUR package manager, sucha as `paru` or `yay`,
for instance.

After installing these packages, you need to use stow to "_install_" their
corresponding dotfiles.

## Installing Dotfiles with Stow

You will need `git` and GNU `stow`

Clone your dotfiles repositpry into your `$HOME` directory or `~`

```bash
git clone https://codeberg.org/your-dotfile-repo ~
```

Run `stow` to symlink everything or just select what you want

```bash
stow */ # Everything (the '/' ignores the README)
```

```bash
stow zsh # Just my zsh config
```


## Creating entries in the dotfile folder

To add a file or folder you want stow to symlink (i.e. to manage), just reproduce the same file/folder structure starting from the home directory to the target entry **inside** the stow-managed dotfile folder.
