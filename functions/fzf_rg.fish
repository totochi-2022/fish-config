function fzf_rg -d "Search content with ripgrep and fzf"
    if test (count $argv) -eq 0
        rg --color=always --line-number --no-heading --smart-case "" |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    else
        set -l query $argv[1]
        rg --color=always --line-number --no-heading --smart-case "$query" |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    end
end