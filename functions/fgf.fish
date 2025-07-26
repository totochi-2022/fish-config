function fgf -d "Find Git files with fzf - interactive mode switcher"
    if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
        echo "Not in a Git repository"
        return 1
    end
    
    set -l mode "tracked"
    
    while true
        switch $mode
            case "tracked"
                set -l header "Tracked Files Mode | Press U:Untracked A:All T:Tracked Q:Quit"
                set -l result (git ls-files | fzf --multi --header="$header" --bind="u:execute(echo untracked)+abort,a:execute(echo all)+abort,t:execute(echo tracked)+abort,q:abort" --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(echo "file:{}")+abort')
                
            case "untracked"
                set -l header "Untracked Files Mode | Press U:Untracked A:All T:Tracked Q:Quit"
                set -l result (git ls-files --others --exclude-standard | fzf --multi --header="$header" --bind="u:execute(echo untracked)+abort,a:execute(echo all)+abort,t:execute(echo tracked)+abort,q:abort" --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(echo "file:{}")+abort')
                
            case "all"
                set -l header "All Files Mode | Press U:Untracked A:All T:Tracked Q:Quit"
                set -l result (begin; git ls-files; git ls-files --others --exclude-standard; end | sort -u | fzf --multi --header="$header" --bind="u:execute(echo untracked)+abort,a:execute(echo all)+abort,t:execute(echo tracked)+abort,q:abort" --preview 'bat --color=always --style=numbers --line-range=:500 {}' --bind 'enter:execute(echo "file:{}")+abort')
        end
        
        if test -z "$result"
            return
        end
        
        switch $result
            case "untracked"
                set mode "untracked"
            case "all"
                set mode "all"
            case "tracked"
                set mode "tracked"
            case "file:*"
                set -l file_path (string sub -s 6 $result)
                if test -f "$file_path"
                    nvim $file_path
                    return
                end
        end
    end
end