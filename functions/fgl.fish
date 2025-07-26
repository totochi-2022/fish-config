function fgl -d "Browse Git log with fzf - interactive mode switcher"
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Not in a Git repository"
        return 1
    end
    
    set -l mode "oneline"
    
    while true
        switch $mode
            case "oneline"
                set -l header "One Line Mode | Press O:Oneline D:Detail G:Graph S:Stat Q:Quit"
                set -l result (git log --oneline --color=always | fzf --ansi --header="$header" --bind="o:execute(echo oneline)+abort,d:execute(echo detail)+abort,g:execute(echo graph)+abort,s:execute(echo stat)+abort,q:abort" --preview 'git show --color=always {1}' --bind 'enter:execute(echo "commit:{1}")+abort')
                
            case "detail"
                set -l header "Detail Mode | Press O:Oneline D:Detail G:Graph S:Stat Q:Quit"
                set -l result (git log --pretty=format:'%h %s (%an, %ar)' --color=always | fzf --ansi --header="$header" --bind="o:execute(echo oneline)+abort,d:execute(echo detail)+abort,g:execute(echo graph)+abort,s:execute(echo stat)+abort,q:abort" --preview 'git show --color=always {1}' --bind 'enter:execute(echo "commit:{1}")+abort')
                
            case "graph"
                set -l header "Graph Mode | Press O:Oneline D:Detail G:Graph S:Stat Q:Quit"
                set -l result (git log --graph --oneline --color=always | fzf --ansi --header="$header" --bind="o:execute(echo oneline)+abort,d:execute(echo detail)+abort,g:execute(echo graph)+abort,s:execute(echo stat)+abort,q:abort" --preview 'git show --color=always {1}' --bind 'enter:execute(echo "commit:{1}")+abort')
                
            case "stat"
                set -l header "Stat Mode | Press O:Oneline D:Detail G:Graph S:Stat Q:Quit"
                set -l result (git log --oneline --stat --color=always | fzf --ansi --header="$header" --bind="o:execute(echo oneline)+abort,d:execute(echo detail)+abort,g:execute(echo graph)+abort,s:execute(echo stat)+abort,q:abort" --preview 'git show --color=always {1}' --bind 'enter:execute(echo "commit:{1}")+abort')
        end
        
        if test -z "$result"
            return
        end
        
        switch $result
            case "oneline"
                set mode "oneline"
            case "detail"
                set mode "detail"
            case "graph"
                set mode "graph"
            case "stat"
                set mode "stat"
            case "commit:*"
                set -l commit_hash (string sub -s 8 $result | string split " " | head -1)
                git show $commit_hash
                return
        end
    end
end