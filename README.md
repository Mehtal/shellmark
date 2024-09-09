
# Zsh Shell Mark Script

A custom Zsh script for quickly marking, navigating, and managing directories in the terminal.

This script was inspired by the mark feature in Neovim, which allows users to set marks within a text document for easy navigation. Similarly, this script provides an efficient way to mark and jump to directories within the terminal, enhancing productivity.

## Features

- **Mark Directories:**
  - Use `md` to mark any directory or `Alt + m` to mark the current directory.
  
- **Navigate to Marked Directories:**
  - Use `goto_mark` or the `Alt + g` shortcut to select and go to a marked directory.

- **Delete Marks:**
  - Use `delete_mark` or the `Alt + d` shortcut to remove a mark from the list.

- **Persistent Configuration:**
  - Marked directories are saved in `config.txt` located in the same directory as the script.

## Installation

1. Download or clone the repository.
2. Save the script in your desired location.
3. Make sure `fzf` is installed for fuzzy finding.
4. Add the following line to your `.zshrc` file to source the script:
   ```zsh
   source /path/to/your/script.sh
## Usage
1. Run md to mark a specific directory or the current directory.
2. Press alt + m to mark current directory
3. Press Alt + g to select a marked directory and navigate to it.
4. Press Alt + d to delete a marked directory.
