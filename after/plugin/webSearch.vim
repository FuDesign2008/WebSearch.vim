"
" webSearch.vim
"
" Author: FuDesign2008@163.com
" Version: 1.0.1
"
" avalable for win32, mac, unix/linux
"
"1. Search the keyword under cursor in normal mode and search selected content quickly.
"   default shortcut is: <leader>ss
"
"2. :WSearch engineName keyword1 keyword2 ...
"   You can config `g:webSearchEngines` to config web search engines in .vimrc
"   e.g.
"       let g:webSearchEngines = {
"           \ 'github': 'https://github.com/search?q=<QUERY>'
"       }
"   then you can use
"       :WSearch github vimKit
"   by default, google and baidu is available to use without config
"       :WSearch google vim kit
"       :WSearch baidu vim kit
"
"3. Search with current search engine
"   :WS keyword1 keyword2 ...
"
"4. Change or echo current search engine
"   :WSEngine  [engineName]
"
"



if exists("g:web_search_loaded")
    finish
endif
let g:web_search_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if strlen(a:url)
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        let urlStr = shellescape(a:url)
        let cmdStr = ''

        if has('win32') || has('win64')
            let cmdStr = 'cmd /c start "" ' . urlStr
        elseif has('mac')
            let cmdStr = 'open -a Safari ' . urlStr
            let findStr = system('ls /Applications/ | grep -i google\ chrome')
            if strlen(findStr) > 5
                let cmdStr = 'open -a Google\ Chrome ' . urlStr
            endif
        elseif has('unix')
            " unix/linux
            let cmdStr = 'xdg-open ' . urlStr
        else
            echomsg 'Url "' . urlStr . '" can NOT be opened!'
            return
        endif

        call system(cmdStr)
        echomsg cmdStr

    endif
endfunction

function! s:GetSelectedContent()
    let content = ''
    let cache = @a
    try
        normal! gv"ay
        let content = @a
    finally
        let @a = cache
    endtry
    "replace \r\n with space and trim
    if content != ''
        let content = substitute(content, '[\r\n]', ' ' , 'g')
        let content = substitute(content, '^ \+', '', '')
        let content = substitute(content, ' \+$', '', '')
    endif
    return content
endfunction

let s:defaultEngines = {
            \ 'google': 'https://encrypted.google.com/search?q=<QUERY>',
            \ 'baidu': 'http://www.baidu.com/s?wd=<QUERY>',
            \ 'mdn': 'https://developer.mozilla.org/en-US/search?q=<QUERY>'
            \}

if !exists('g:webSearchEngines')
    let g:webSearchEngines = {}
endif


if !has_key(g:webSearchEngines, 'google')
    let g:webSearchEngines['google'] = s:defaultEngines['google']
endif
if !has_key(g:webSearchEngines, 'baidu')
    let g:webSearchEngines['baidu'] = s:defaultEngines['baidu']
endif
if !has_key(g:webSearchEngines, 'mdn')
    let g:webSearchEngines['mdn'] = s:defaultEngines['mdn']
endif

if !exists('g:webSearchCurrentEngine')
    let g:webSearchCurrentEngine = 'google'
endif

function! s:WebSearch(engineName, ...)
    if !has_key(g:webSearchEngines, a:engineName)
        echomsg 'Do NOT support search engine: ' . a:engineName
        return
    endif
    let query =  substitute(join(a:000, ' '), ' ', '+', 'g')
    if strlen(query)
        let url = substitute(g:webSearchEngines[a:engineName], '<QUERY>', query, '')
        call s:OpenUrl(url)
    endif
endfunction

function! s:WebSearchCurrent(...)
    call s:WebSearch(g:webSearchCurrentEngine, join(a:000, ' '))
endfunction

function! s:CurrentEngine(...)
    if len(a:000)
        let g:webSearchCurrentEngine = a:000[0]
    else
        echo 'WebSearch current engine: ' . g:webSearchCurrentEngine
    endif
endfunction


function! WebSearchSelected()
    let keyword = s:GetSelectedContent()
    call s:WebSearch(g:webSearchCurrentEngine, keyword)
endfunction

function! WebSearchUnderCursor()
        call s:WebSearch(g:webSearchCurrentEngine, expand('<cword>'))
endfunction

command! -nargs=+ WSearch call s:WebSearch(<f-args>)
command! -nargs=+ WS call s:WebSearchCurrent(<f-args>)
command! -nargs=? WSEngine call s:CurrentEngine(<f-args>)
"in visual mode, if has no `<esc>`, the command will be executed
"as times as the number of selected lines
vnoremap <leader>ss <esc>:call WebSearchSelected()<CR>
nnoremap <leader>ss <esc>:call WebSearchUnderCursor()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
