function fzf_git_files -d "Find Git files with fzf"
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Not in a Git repository"
        return 1
    end
    
    git ls-files |
    fzf --multi \
        --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
        --bind 'enter:execute(nvim {+})'
end