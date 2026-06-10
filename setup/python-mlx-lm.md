# Python and MLX-LM Setup

This is a small pyenv-based recipe for keeping Python current enough for AI
tooling without turning Python into a global system dependency.

## Mental Model

Coming from Ruby, the mapping is roughly:

```text
rbenv        -> pyenv
ruby         -> python
gem          -> pip
gems         -> packages / libraries
Bundler      -> venv plus requirements files, roughly
bundle exec  -> activated venv, or PYENV_VERSION=... command
```

The practical model is:

```text
pyenv chooses the Python interpreter
venv creates an isolated package sandbox for one Python
pip installs packages into the active Python environment
```

Prefer this form when installing or inspecting packages:

```sh
python -m pip install some-package
python -m pip list
python -m pip --version
```

That guarantees `pip` belongs to the same `python` you are running. Avoid
using `sudo pip install`.

Each Python environment usually has one `pip`, but it may expose multiple
command names such as `pip`, `pip3`, and `pip3.13`. The reliable check is:

```sh
python -m pip --version
```

Python 2 is no longer relevant for modern Python work. The real compatibility
question is usually which Python 3 version a package supports, such as `3.11`,
`3.12`, or `3.13`.

## Assumptions

- macOS on Apple silicon.
- Homebrew is installed.
- `pyenv` is already part of the shell setup.
- Python packages should live in an isolated environment, not the global Python.

## Check Current State

```sh
command -v pyenv
pyenv --version
pyenv versions
pyenv global
python3 --version
python3 -m pip --version
```

## Update pyenv

```sh
brew update
brew upgrade pyenv
```

If pyenv came from git instead of Homebrew, update it from its install
directory instead.

```sh
git -C "$(pyenv root)" pull
```

## Pick a Python Version

List current stable Python versions known to pyenv.

```sh
pyenv install --list | rg '^\s*3\.(12|13)\.[0-9]+$'
```

Choose the newest patch release that works for your tools. For this setup,
Python `3.13.13` worked with `mlx-lm`.

```sh
pyenv install 3.13.13
```

Optional: make it your default Python.

```sh
pyenv global 3.13.13
pyenv rehash
```

If you do not want to change the machine default, skip `pyenv global` and use
`PYENV_VERSION=3.13.13` when creating the virtual environment.

## Create an Isolated MLX-LM Environment

This creates a normal Python `venv` inside pyenv's versions directory. pyenv
will then treat it like a selectable version named `mlx-lm`.

```sh
"$(pyenv root)/versions/3.13.13/bin/python" -m venv \
  "$(pyenv root)/versions/mlx-lm"

"$(pyenv root)/versions/mlx-lm/bin/python" -m pip install --upgrade \
  pip setuptools wheel

"$(pyenv root)/versions/mlx-lm/bin/python" -m pip install --upgrade mlx-lm

pyenv rehash
```

## Use It Temporarily

```sh
PYENV_VERSION=mlx-lm python --version
PYENV_VERSION=mlx-lm python -m pip --version
PYENV_VERSION=mlx-lm mlx_lm.generate --help
```

Or activate it for the current shell.

```sh
pyenv shell mlx-lm
python --version
mlx_lm.generate --help
```

Reset the shell back to normal.

```sh
pyenv shell --unset
```

## Verify Install

```sh
PYENV_VERSION=mlx-lm python -c \
  "import mlx, mlx_lm; print('mlx import ok'); print('mlx_lm import ok')"

PYENV_VERSION=mlx-lm python -m pip show mlx-lm mlx
```

Useful installed commands include:

```sh
PYENV_VERSION=mlx-lm mlx_lm.generate --help
PYENV_VERSION=mlx-lm mlx_lm.chat --help
PYENV_VERSION=mlx-lm mlx_lm.server --help
```

## Jupyter Notes

Jupyter adds one extra layer. The Jupyter app/server and the notebook kernel can
use different Python environments.

Common failure mode:

```text
mlx-lm is installed in the mlx-lm environment, but the notebook is using a
different kernel, so import mlx_lm fails.
```

For a simple setup, install and run Jupyter inside the same environment:

```sh
pyenv shell mlx-lm
python -m pip install --upgrade jupyterlab ipykernel
python -m jupyter lab
```

For a cleaner setup, register the `mlx-lm` environment as a kernel that any
Jupyter install can use:

```sh
pyenv shell mlx-lm
python -m pip install --upgrade ipykernel
python -m ipykernel install --user \
  --name mlx-lm \
  --display-name "Python 3.13 mlx-lm"
```

Then choose `Python 3.13 mlx-lm` from Jupyter's kernel selector.

Inside a notebook, check the actual Python being used:

```python
import sys
print(sys.executable)
```

For this setup, it should point near:

```text
/Users/dgdosen/.pyenv/versions/mlx-lm/bin/python
```

## Update Later

Update pip tooling and `mlx-lm` inside the isolated environment.

```sh
PYENV_VERSION=mlx-lm python -m pip install --upgrade pip setuptools wheel
PYENV_VERSION=mlx-lm python -m pip install --upgrade mlx-lm
pyenv rehash
```

If a newer Python is needed later, install it with pyenv and recreate the
environment.

```sh
pyenv install 3.13.x
rm -rf "$(pyenv root)/versions/mlx-lm"
"$(pyenv root)/versions/3.13.x/bin/python" -m venv \
  "$(pyenv root)/versions/mlx-lm"
PYENV_VERSION=mlx-lm python -m pip install --upgrade pip setuptools wheel mlx-lm
pyenv rehash
```
