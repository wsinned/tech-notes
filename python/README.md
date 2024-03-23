# Python Notes

## asdf

I use [asdf](https://github.com/asdf-vm/asdf) to manage language runtimes. It isn't perfect, but it's a fairly consistent way to get the correct language version and runtime on a per-project basis.

## pipx

I use [pipx](https://pypa.github.io/pipx/) to manage user level instals of python applications in an attempt to isolate myself from the problems of global installs and polluting the system Python installation with extraneous packages and their dependencies.

### Pitfalls

When upgrading Python, either via Homebrew or asdf and setting a new Global version, it is common to see applications installed with the application failing because of a missing python dependency.

This isn't immediately obvious as it shows up in a stack trace. Using pipx to upgrade doesn't work. On macOS, don't use the pipx provided by Homebrew as you have less control over when the underlying python version is upgraded. I switched to using my asdf global Python version and pipx installed via:

```bash
python3 -m pip install --user pipx
```

What you need to do is ensure that it continues to work is install pipx in the new Python and then run

```bash
asdf install python latest:3.11

asdf global python 3.11.6

python3 -m pip install --user pipx

pipx reinstall-all
```

This will update all the symbolic links in the virtual environments and your Python applications will work again.

If there is a problem not finding python on NixOS, it is probably that the venv refers to a specific derivation that has been removed/garbage collected. Simply remove the venv and reinstall.

```bash
rm -rf .local/pipx/venvs/take-note-cli
```
