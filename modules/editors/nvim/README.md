# Neovim keybindings

Leader is `<space>`. Local leader is `,`.

`<leader>fk` searches every keymap, including the ones from plugins and Neovim itself.

## Normal keys rebindings
- `[`:
  - `q`: Go to the previous element in the quickfix list
  - `Q`: Go to the first element in the quickfix list
  - `w`: Go to the previous element in the location list
  - `W`: Go to the first element in the location list
  - `c`: Go to the previous git hunk

- `]`:
  - `q`: Go to the next element in the quickfix list
  - `Q`: Go to the last element in the quickfix list
  - `w`: Go to the next element in the location list
  - `W`: Go to the last element in the location list
  - `c`: Go to the next git hunk

- `g`:
  - `<`: Move the current tab to the left
  - `>`: Move the current tab to the right

- `H`: Same as `^`
- `L`: Same as `$`
- `Q`: Same as `@@`, repeats the last macro
- `Y`: Yank to the system clipboard
- `<C-p>`: Same as `<C-^>`, switches to the alternate file
- `<C-q>`: Same as `<C-w>q`
- `<C-s>`: Write the buffer
- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: Move between Neovim splits and tmux panes
- `ih`: Git hunk text object, in operator-pending and visual mode
- `.` in visual mode: Repeat the last change on each selected line

## Language server keybindings
> These keys are buffer-local and exist only when a language server is attached:
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation
- `gr`: List references in fzf-lua

> Neovim provides these by default:
- `K`: Hover symbol on the cursor
- `[d`: Go to the previous diagnostic
- `]d`: Go to the next diagnostic
- `<C-s>` in insert mode: Show signature help

## Completion keybindings
> Insert mode, while the completion menu is open:
- `<Tab>`: Select the next item, or jump to the next snippet placeholder
- `<S-Tab>`: Select the previous item, or jump to the previous snippet placeholder
- `<CR>`: Accept the selected item
- `<C-Space>`: Open the menu. Press it again to show or hide the documentation
- `<C-e>`: Close the menu
- `<C-d>`: Scroll the documentation up
- `<C-f>`: Scroll the documentation down

## Fuzzy finder keybindings
> Inside any fzf-lua file picker:
- `<C-q>`: Send the selected entries to the quickfix list
- `<C-a>`: Select all entries
- `<C-t>`: Open in a new tab
- `<C-x>`: Open in a horizontal split
- `<C-v>`: Open in a vertical split

## Leader key keybindings
- Leader: `<space>`

  - `.`: Find git-tracked files
  - `;`: Grep the project, including hidden files
  - `/`: Search lines in open buffers
  - `,`: Find open buffers
  - `e`: Toggle the file explorer
  - `z`: Toggle zen mode
  - `1` to `9`: Go to the buffer in that tab position
  - `D`: Go to type definition (language server)

  - `b`: Buffers
    - `d`: Delete the buffer and keep the window open

  - `f`: Find
    - `f`: Files, including hidden files
    - `c`: Git commits
    - `h`: Vim help tags
    - `m`: Man pages
    - `k`: Keymaps

  - `t`: Tabs, tests, and git toggles

    > Tabs
    - `o`: Prompt for a file to open in a new tab
    - `q`: Close the current tab

    > Tests
    - `f`: Run tests in the current file
    - `s`: Run the test suite
    - `l`: Run the last test
    - `n`: Run the test nearest to the cursor
    - `v`: Jump to where the last test ran

    > Git
    - `b`: Toggle inline blame for the current line
    - `d`: Preview the hunk inline

  - `l`: Language server
    - `f`: Format the current buffer (prettier or ocamlformat, falls back to the language server)

    > These keys exist only when a language server is attached
    - `r`: Rename the symbol on the cursor
    - `a`: Request code actions on the cursor
    - `s`: Search workspace symbols
    - `q`: Open diagnostics in a location list
    - `d`: Open a popup with the current diagnostic

  - `h`: Git hunks
    - `s`: Stage the hunk, or unstage it if it is already staged. Stages the selected lines in visual mode
    - `r`: Reset the hunk. Resets the selected lines in visual mode
    - `S`: Stage the buffer
    - `R`: Reset the buffer
    - `p`: Preview the hunk
    - `b`: Show the full blame of the current line
    - `d`: Diff against the index
    - `D`: Diff against the last commit

  - `g`: Git
    - `g`: Open the vim-fugitive status in a new tab
    - `m`: Show the full blame of the current line
    - `d`: Open a split diff of the current file
    - `D`: Run `git diff`
    - `l`: Show the git log

  - `p`: Project
    - `t`: List project TODOs in the quickfix list

  - `a`: Claude Code
    > Start `claude` in a tmux pane and run `/ide` to connect it to Neovim
    - `s`: Send the visual selection. In the file explorer, add the file under the cursor
    - `b`: Add the current file
    - `a`: Accept the proposed diff
    - `d`: Deny the proposed diff

  - `v`: Vim
    - `r`: Reload the configuration
    - `q`: Quit vim, stopping if there are unsaved buffers
    - `Q`: Quit vim, ignoring any unsaved buffers

  - `d`: Debug
    - `d`: Toggle a breakpoint on the current line
    - `D`: Set a conditional breakpoint on the current line
    - `l`: Set a log point on the current line
    - `f`: Start or continue debugging
    - `u`: Toggle the debugging UI
    - `r`: Open the nvim-dap REPL
    - `j`: Step out
    - `k`: Step into

## Screen layout
- The tab bar shows open buffers. It appears only when two or more buffers are open.
- One statusline spans the whole screen.
- Diagnostics show as signs and underlines. `<leader>ld` opens the message.
- Zen mode (`<leader>z`) centers the buffer and hides line numbers, signs, the cursor line, the ruler, git signs, the statusline, and the tmux statusline.
- Markdown buffers render headings, lists, tables, and code blocks in place. The line under the cursor shows the raw text. Line numbers and the ruler are off in markdown buffers.
