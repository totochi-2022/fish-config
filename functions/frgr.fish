function frgr -d "Search content from root with ripgrep and fzf"
    if test (count $argv) -eq 0
        rg --color=always --line-number --no-heading --smart-case --hidden "" / --glob '!proc/*' --glob '!sys/*' --glob '!dev/*' --glob '!mnt/*' --glob '!snap/*' --glob '!tmp/*' 2>/dev/null |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    else
        set -l query $argv[1]
        rg --color=always --line-number --no-heading --smart-case --hidden "$query" / --glob '!proc/*' --glob '!sys/*' --glob '!dev/*' --glob '!mnt/*' --glob '!snap/*' --glob '!tmp/*' 2>/dev/null |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    end
end