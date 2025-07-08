function fzf_git_log -d "Browse Git log with fzf"
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Not in a Git repository"
        return 1
    end
    
    git log --oneline --color=always |
    fzf --ansi \
        --preview 'git show --color=always {1}' \
        --bind 'enter:execute(git show {1} | less -R)'
end