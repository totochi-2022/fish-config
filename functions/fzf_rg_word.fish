function fzf_rg_word -d "Search for word under cursor with ripgrep and fzf"
    set -l word (commandline -t)
    if test -z $word
        echo "No word under cursor"
        return 1
    end
    rg --color=always --line-number --no-heading --smart-case $word |
    fzf --ansi \
        --delimiter : \
        --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
        --preview-window '+{2}-/2' \
        --bind 'enter:execute(nvim {1} +{2})'
end