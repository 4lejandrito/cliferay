#!/bin/sh

set -e

if command -v cliferay >/dev/null 2>&1; then
  INSTALL_DIR=$(cliferay source-folder)
else
  INSTALL_DIR="$HOME/.cliferay"
fi

if [ -d "$INSTALL_DIR" ]; then
  cd "$INSTALL_DIR"
  git pull
  cd - > /dev/null
else
  git clone git@github.com:4lejandrito/cliferay.git "$INSTALL_DIR"
fi

PROFILE=""
SHELL_NAME=$(basename "$SHELL")

if [ "$SHELL_NAME" = "zsh" ]; then
  PROFILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    PROFILE="$HOME/.bashrc"
  elif [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
  fi
elif [ -f "$HOME/.profile" ]; then
  PROFILE="$HOME/.profile"
fi

CLIFERAY_SETUP=$({
  echo "\n# cliferay"
  echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\""
  echo 'eval "$(cliferay completions)"'
  echo 'eval "$(cliferay aliases)"'
})

if [ -n "$PROFILE" ]; then
  if ! grep -q 'cliferay/bin' "$PROFILE"; then
    echo "Updating your shell profile at $PROFILE"
    echo "$CLIFERAY_SETUP" >> "$PROFILE"
    echo "Please restart your shell or run 'source $PROFILE' to apply the changes."
  fi
else
  echo "Please add the following to your shell's configuration file:"
  echo "$CLIFERAY_SETUP\n"
fi

echo "Installation complete. Enjoy cliferay!"