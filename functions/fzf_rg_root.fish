function fzf_rg_root -d "Search content with ripgrep in root directory"
    if test (count $argv) -eq 0
        rg --color=always --line-number --no-heading --smart-case "" / \
            --glob '!proc/*' --glob '!sys/*' --glob '!dev/*' --glob '!run/*' \
            --glob '!tmp/*' --glob '!var/lib/*' --glob '!snap/*' 2>/dev/null |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    else
        set -l query $argv[1]
        rg --color=always --line-number --no-heading --smart-case "$query" / \
            --glob '!proc/*' --glob '!sys/*' --glob '!dev/*' --glob '!run/*' \
            --glob '!tmp/*' --glob '!var/lib/*' --glob '!snap/*' 2>/dev/null |
        fzf --ansi \
            --delimiter : \
            --preview 'bat --color=always --style=numbers --line-range={2}: {1}' \
            --preview-window '+{2}-/2' \
            --bind 'enter:execute(nvim {1} +{2})'
    end
end