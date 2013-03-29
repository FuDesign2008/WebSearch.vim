"
" webSearch.vim
"
" avalable for win32, mac, unix/linux
"
"1. Google/Baidu with keyword under cursor
"   the shortcur key is: <leader>G /<leader>B
"2. :Google keyword1 keyword2
"   :Baidu keyword1 keyword2
"
"3. :WebSearch engineName keyword1 keyword2
"   You can config `g:webSearchEngines` to config web search engines in .vimrc
"   e.g.
"       let g:webSearchEngines = {
"           \ 'github': 'https://github.com/search?q=<QUERY>'
"       }
"   then you can use
"       :WebSearch github vimKit
"   by default, google and baidu is able to use without config
"       :WebSearch google vim kit
"       :WebSearch baidu vim kit
"



if &cp || exists("g:web_search")
    finish
endif
let g:web_search = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:OpenUrl(url)
    if strlen(a:url)
        " open url from shell command line
        " @see http://www.dwheeler.com/essays/open-files-urls.html
        "
        if has('win32')
            silent exec "!cmd /c start " . a:url
            echomsg 'open url "' . a:url . '" ...'
        elseif has('mac')
            silent exec "!open '". a:url ."'"
            echomsg 'open url "' . a:url . '" ...'
        elseif has('unix')
            " unix/linux
            silent exec "!xdg-open '". a:url ."'"
            echomsg 'open url "' . a:url . '" ...'
        else
            echomsg 'Url "' . a:url . '" can NOT be opened!'
        endif
    endif
endfunction

let s:defaultEngins = {
            \ 'google': 'https://encrypted.google.com/search?q=<QUERY>',
            \ 'baidu': 'http://www.baidu.com/s?wd=<QUERY>'
            \}

function! s:MergeDefaultEngines(key, val)
    if !has_key(g:webSearchEngines, a:key)
        g:webSearchEngines[a:key] = a:val
    endif
endfunction

if !exists('g:webSearchEngines')
    let g:webSearchEngines = s:defaultEngins
else
    map(g:webSearchEngines, 's:MergeDefaultEngines(v:key, v:val)')
endif


function! s:WebSearch(engineName, ...)
    if !has_key(g:webSearchEngines, a:engineName)
        echomsg 'Do NOT support search engine: ' . a:engineName
    endif
    let query =  substitute(join(a:000, ' '), ' ', '+', 'g')
    if strlen(query)
        let url = substitute(g:webSearchEngines[a:engineName], '<QUERY>', query, '')
        call s:OpenUrl(url)
    endif
endfunction

command -nargs=+ WebSearch call s:WebSearch(<f-args>)



if has_key(g:webSearchEngines, 'google')
    function! s:GoogleSearch(...)
        let keywords = join(a:000, ' ')
        call s:WebSearch('google', keywords)
    endfunction

    function! GoogleKeyword()
        let keyword = expand('<cword>')
        call s:GoogleSearch(keyword)
    endfunction

    command -nargs=+ Google call s:GoogleSearch(<f-args>)
    noremap <leader>G :call GoogleKeyword()<CR>
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

    command -nargs=+ Baidu call s:BaiduSearch(<f-args>)
    noremap <leader>B :call BaiduKeyword()<CR>
endif


let &cpo = s:save_cpo
