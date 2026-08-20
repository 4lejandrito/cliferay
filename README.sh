#!/bin/bash

echo '# Cliferay

Read [the full documentation](docs/README.md).

```
'"$(NO_COLOR=1 ./bin/cliferay --help)"'
```

## Installation

```bash
curl -sSL https://raw.githubusercontent.com/4lejandrito/cliferay/master/install.sh | sh
```

## Manual Installation

1. Clone this repo.
2. Add the `bin` folder to your path:
    ```bash
    export PATH=/path/to/cliferay/bin:$PATH
    ```
3. Run it!
    ```bash
    cliferay --help
    ```
4. To enable bash completions, add this to your `.bash_profile`, `.zshrc`, or similar:
    ```bash
    eval "$(cliferay completions)"
    ```
5. To enable aliases (like `gw`), add this to your `.bash_profile`, `.zshrc`, or similar:
    ```bash
    eval "$(cliferay aliases)"
    ```

> **Note for macOS users:**
> You need to install `coreutils`. You can install it via Homebrew:
>
> ```sh
> brew install coreutils
> ```
>
> Then, add the `gnubin` directory to your `PATH` in your `.zshrc` or `.bashrc`:
>
> ```sh
> # Use coreutils installed via Homebrew: https://www.gnu.org/software/coreutils/
> export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
> ```

## Claude Code plugin

This repo also ships the `cliferay` Claude Code plugin. It exposes a `todo` skill, so you can read and manage your todos by asking Claude instead of opening the board.

To install:

```bash
claude plugin marketplace add 4lejandrito/cliferay
claude plugin install cliferay@cliferay
```

To try local changes, run this from your clone instead:

```bash
claude plugin marketplace add ./
claude plugin install cliferay@cliferay
```

## Contributing

`cliferay` was created with [bashly.dev](https://bashly.dev). To contribute, please familiarize yourself with it first.

### Modify an existing command

1. Make changes inside `src/commands`.
2. Run `make`.
3. Test with `cliferay [COMMAND] ...`
4. Submit a pull request!

### Add a new command

1. Update `src/bashly.yml` with your new command.
2. Run `make`.
3. Implement your command inside `src/commands`.
4. Run `make` again.
5. Test with `cliferay [COMMAND] ...`
6. Submit a pull request!'