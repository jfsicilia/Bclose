# Bclose command.

This script creates a Bclose command to close a buffer. If there are more
loaded buffers it shows alternative ('#') buffer (first option) or next buffer
(second option) in the current window. If there are no more buffers it creates
a scratch buffer in the current window. Command checks if buffer has been
modified, not deleting it if true. If you wish to discard changes, you can
call it with ! (e.g. :Bclose!).

This script in combination with **NERDTree** plugin, takes vim to behave like
a top IDE.

*Original plugin from (give credit to them!):
[vim.wikia.com](http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window)*

I took Kwbd command from above URL, renamed it to Bclose, refactor some code
and checked if a file has been modified.

## Installation.

Download or clone it, and put bclose.vim into your ~/.vim/plugin folder.

If you use **Vundle**, add to your .vimrc:

`Plugin 'jfsicilia/bclose'`

## Usage.

To close a buffer type:

`:Bclose`

If the buffer has been modified, previous command will warn you, and take no
action. To discard changes type:

`:Bclose!`

## Optional.

You can set key mappings to fast close or write&close buffers.

```
" Closes buffer and deletes it, bringing next buffer to current window.
nnoremap <leader>q :Bclose<CR>

" Writes buffer and deletes it, bringing next buffer to current window.
nnoremap <leader>wq :w<CR>:Bclose<CR>
```


