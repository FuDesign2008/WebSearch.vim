WebSearch.vim
=============

Integrating web search engines, such as Google, into vim

##Usage

###:WSearch
The general usage is: `:WSearch engineName keyword1 keyword2 ...`. For
example:

```vim
:WSearch google keyword1 keyword2 ...
:WSearch baidu keyword1 keyword2 ...
```
By default, `google`, `baidu` and `mdn` is available without configuration.

###:WS
If you set the current search engine, you can use `:WS` command. The syntax is

```vim
:WS keyword1 keyword2 ...
```

You can set the current search engine in `.vimrc` :

```vim
let g:webSearchCurrentEngine = 'google'
```
or set it danymically:

```vim
:WSEngine google
```

If you want to know the current search engine, just execute the command:
```vim
:WSEngine
```
and press `enter` key. The result may be like this
```
WebSearch current engine: google
```

###Shortcut

There are shortcuts to search the word under cursor:

* `<leader>ss` to search the word under cursor with current search engine in
normal mode.

* `<leader>ss` to search the selected text with current search engine in visual
mode.


##Custom Search Engines

You can config `g:webSearchEngines` to add web search engines in `.vimrc`.
e.g.

```vim
let g:webSearchEngines = {
    \ 'github': 'https://github.com/search?q=<QUERY>'
    \ }
```

Then you can use this command:

```vim
:WSearch github keyword1 keyword2 ...
```

The `<QUERY>` will be replaced with the keywords when you are searching.



