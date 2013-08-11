"
" webSearch.vim
"
" Author: FuDesign2008@163.com
" Version: 1.0.1
"
" avalable for win32, mac, unix/linux
"
"1. Google/Baidu/MDN with keyword under cursor
"   the shortcur key is: <leader>gg/bd/mz
"2. :Google keyword1 keyword2 ...
"   :Baidu keyword1 keyword2 ...
"   :Mdn keyword1 keyword2 ...
"
"3. :WebSearch engineName keyword1 keyword2
"   You can config `g:webSearchEngines` to config web search engines in .vimrc
"   e.g.
"       let g:webSearchEngines = {
"           \ 'github': 'https://github.com/search?q=<QUERY>'
"       }
"   then you can use
"       :WebSearch github vimKit
"   by default, google and baidu is available to use without config
"       :WebSearch google vim kit
"       :WebSearch baidu vim kit
"



if &cp || exists("g:web_search_loaded")
    finish
endif
let g:web_search_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if strlen(a:url)
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        let urlStr = a:url
        " replace # with \#, or else # will be replace with alternative file
        " in vim
        let urlStr = substitute(urlStr, '#', '\\#', '')
        if has('win32') || has('win64')
            silent exec '!cmd /c start "" "' . urlStr . '"'
            echomsg 'open url "' . urlStr . '" ...'
        elseif has('mac')
            silent exec "!open '". urlStr ."'"
            echomsg 'open url "' . urlStr . '" ...'
        elseif has('unix')
            " unix/linux
            silent exec "!xdg-open '". urlStr ."'"
            echomsg 'open url "' . urlStr . '" ...'
        else
            echomsg 'Url "' . urlStr . '" can NOT be opened!'
        endif
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

"function! s:MergeDefaultEngines(key, val)
    "echomsg a:key . ': ' a:val
    "if !has_key(g:webSearchEngines, a:key)
        "let g:webSearchEngines[a:key] = a:val
    "endif
"endfunction

if !exists('g:webSearchEngines')
    let g:webSearchEngines = {}
endif

"map(s:defaultEngines, 's:MergeDefaultEngines(v:key, v:val)')

if !has_key(g:webSearchEngines, 'google')
    let g:webSearchEngines['google'] = s:defaultEngines['google']
endif
if !has_key(g:webSearchEngines, 'baidu')
    let g:webSearchEngines['baidu'] = s:defaultEngines['baidu']
endif
if !has_key(g:webSearchEngines, 'mdn')
    let g:webSearchEngines['mdn'] = s:defaultEngines['mdn']
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

command! -nargs=+ WebSearch call s:WebSearch(<f-args>)



if has_key(g:webSearchEngines, 'google')
    function! s:GoogleSearch(...)
        let keywords = join(a:000, ' ')
        call s:WebSearch('google', keywords)
    endfunction

    function! GoogleKeyword()
        silent let keyword = s:GetSelectedContent()
        if keyword == ''
            let keyword = expand('<cword>')
        endif
        echo keyword
        let pos = getpos('.')
        echo pos
        "call s:GoogleSearch(keyword)
    endfunction

    command! -nargs=+ Google call s:GoogleSearch(<f-args>)
    "unmap <leader>gg
    "in visual mode, if has no `<esc>`, the command will be executed
    "as times as the number of selected lines
    noremap <leader>gg <esc>:call GoogleKeyword()<CR>
endif

if has_key(g:webSearchEngines, 'baidu')
    function! s:BaiduSearch(...)
        let keywords = join(a:000, ' ')
        call s:WebSearch('baidu', keywords)
    endfunction

    function! BaiduKeyword()
        let keyword = expand('<cword>')
        call s:BaiduSearch(keyword)
    endfunction

    command! -nargs=+ Baidu call s:BaiduSearch(<f-args>)
    "unmap <leader>bd
    noremap <leader>bd <esc>:call BaiduKeyword()<CR>
endif

if has_key(g:webSearchEngines, 'mdn')
    function! s:MDNSearch(...)
        let keywords = join(a:000, ' ')
        call s:WebSearch('mdn', keywords)
    endfunction

    function! MDNKeyword()
        let keyword = expand('<cword>')
        call s:MDNSearch(keyword)
    endfunction

    command! -nargs=+ Mdn call s:MDNSearch(<f-args>)
    "unmap <leader>mz
    noremap <leader>mz <esc>:call MDNKeyword()<CR>
endif


let &cpo = s:save_cpo
