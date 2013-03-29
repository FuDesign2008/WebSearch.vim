WebSearch.vim
=============

Integrate web search engines, such as Google ,  in vim

###Google/Baidu the keyword under cursor

   the shortcur key is: `<leader>G`,  `<leader>B`

###Support searching in ex command

   ```vim
   :Google keyword1 keyword2 ...
   :Baidu keyword1 keyword2 ...
   ```

###The ultra command

    ```vim
    :WebSearch engineName keyword1 keyword2
    ```

You can config `g:webSearchEngines` to config web search engines in `.vimrc`.
e.g.

    ```vim
    let g:webSearchEngines = {
        \ 'github': 'https://github.com/search?q=<QUERY>'
        \ }
    ```

Then you can use this command:

    ```vim
    :WebSearch github keyword1 keyword2 ...
    ```

The `<QUERY>` will be replace with the keywords when you are searching.
By default, google and baidu is able to use without config.

    ```vim
    :WebSearch google keyword1 keyword2 ...
    :WebSearch baidu keyword1 keyword2 ...
    ```
