" It creates a Bclose command to close a buffer. If there are more loaded
" buffers it shows alternative or next buffer in the current window. If there
" are no more buffers it creates a scratch buffer in the current window.
" Command checks if buffer has been modified, not deleting it if true. If you
" wish to discard changes, you can't call it with ! (e.g.  :Bclose!).
"
" Original plugin from (give credit to them!):
" http://vim.wikia.com/wiki/Deleting_a_buffer_without_closing_the_window

" I took Kwbd command from above URL, renamed it to Bclose, and add some code
" to check if a file has been modified.
"

" Load plugin once.
if exists('g:loaded_bclose')
    finish
endif
let g:loaded_bclose = 1

" Display an error message function.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Delete the buffer; keep windows; create a scratch buffer if no buffers left.
function! s:Bclose(bang)
    " If a file is not isted then delete it.
    if(!buflisted(winbufnr(0)))
      bw!
      return
    endif
    let s:bufNum = bufnr("%")
    let s:bufName = bufname("%")
    let s:winNum = winnr()
    " If buffer is modified and :Bclose not call with ! (:Bclose!), then
    " a warning is shown to user.
    if empty(a:bang) && getbufvar(s:bufNum, '&modified')
        call s:Warn('No write since last change for buffer '
                    \ .s:bufName. ' (use :Bclose!)')
        return
    endif
    " Checks if there is an alternative buffer to switch to. If there is one,
    " tries to change to that one. If not, tries to change to next buffer.
    let prevbufvar = bufnr("#")
    if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:bufNum)
        b #
    else
        bn
    endif
    execute s:winNum . 'wincmd w'
    " Number of loaded buffers (original buffer won't count).
    let s:buflistedLeft = 0
    " Buffer number of the first of any unloaded buffers.
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:bufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    " If there are no more loaded buffers, it tries to load an unloaded
    " buffer, and if there aren't, creates a new one.
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:winNum . 'wincmd w'
    endif
    " Destroys original buffer.
    if(buflisted(s:bufNum) || s:bufNum == bufnr("%"))
      execute "bw! " . s:bufNum
    endif
    " Configs new buffer as a scratch buffer.
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
endfunction

command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>')
nnoremap <silent> <Plug>Bclose :<C-u>Bclose<CR>

" You can use some key mapping in your .vimrc to access to Bclose command.

" Closes buffer and deletes it, bringing next buffer to current window.
" nnoremap <leader>q :Bclose<CR>

" Writes buffer and deletes it, bringing next buffer to current window.
" nnoremap <leader>wq :w<CR>:Bclose<CR>
