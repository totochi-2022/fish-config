function frgh -d "Search content from home with ripgrep and fzf"
    if test (count $argv) -eq 0
        rg --color=always --line-number --no-heading --smart-case --hidden "" ~ |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    else
        set -l query $argv[1]
        rg --color=always --line-number --no-heading --smart-case --hidden "$query" ~ |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    end
end