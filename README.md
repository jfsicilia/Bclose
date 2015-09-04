# Bclose command.

This script creates a Bclose command to close a buffer. If there are more
loaded buffers it shows alternative or next buffer in the current window. If
there are no more buffers it creates a scratch buffer in the current window.
Command checks if buffer has been modified, not deleting it if true. If you
wish to discard changes, you can't call it with ! (e.g.  :Bclose!).

Original plugin from (give credit to them!):
(http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window)

I took Kwbd command from above URL, renamed it to Bclose, refactor some code
and add check if a file has been modified.

## Usage.

To close a buffer simply:

`:Bclose`

If the buffer has been modified, previous command will warn you, and take no
action. To discard changes, simply:

`:Bclose`

## Optional.

You can set key mappings to fast close or write&close buffers.

```
" Closes buffer and deletes it, bringing next buffer to current window.
nnoremap <leader>q :Bclose<CR>

" Writes buffer and deletes it, bringing next buffer to current window.
nnoremap <leader>wq :w<CR>:Bclose<CR>
```


