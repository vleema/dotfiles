# Dotfiles

This repo contains some configuration files for a small set of basic programs. The dotfiles are managed with the GNU `stow` command.

This repo also contains a [installation guide](/installation.md) and lists of packages you will need to install to get your minimal system running.

## List of Packages

You may find a [**list**](./pacman.pkg) of packages you need to install via pacman.

This [**other list**](./aur.pkg) has a list of packages only available from AUR. Please, use your favorite AUR package manager, such as `paru` or `yay`, for instance.

You can install the packages with `pacman` and `paru` like this:

```bash
paru -Syu --needed - < pacman.pkg
```

After installing these packages, you need to use stow to "_install_" their corresponding dotfiles.

> [!NOTE]
> Not all of the packages are required e.g. onedrive-abbraunegg, station-bin, zen-browser and others. Take a look at the packages before installing them.

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
