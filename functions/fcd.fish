function fcd -d "Change directory with fzf - interactive mode switcher"
    set -l mode "current"
    set -l search_path "."
    
    while true
        switch $mode
            case "current"
                set -l header "Current Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set -l dir (find $search_path -type d -not -path '*/.*' | fzf --header="$header" --bind="h:execute(echo home)+abort,r:execute(echo root)+abort,c:execute(echo current)+abort,q:abort" --preview 'eza --tree --level=2 --color=always {}')
                
            case "home"
                set -l header "Home Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set search_path "~"
                set -l dir (find ~ -type d | fzf --header="$header" --bind="h:execute(echo home)+abort,r:execute(echo root)+abort,c:execute(echo current)+abort,q:abort" --preview 'eza --tree --level=2 --color=always {}')
                
            case "root"
                set -l header "Root Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set search_path "/"
                set -l dir (find / -type d -not -path '/proc/*' -not -path '/sys/*' -not -path '/dev/*' -not -path '/mnt/*' -not -path '/snap/*' -not -path '/tmp/*' 2>/dev/null | fzf --header="$header" --bind="h:execute(echo home)+abort,r:execute(echo root)+abort,c:execute(echo current)+abort,q:abort" --preview 'eza --tree --level=2 --color=always {}')
        end
        
        if test -z "$dir"
            return
        end
        
        switch $dir
            case "home"
                set mode "home"
            case "root"
                set mode "root"
            case "current"
                set mode "current"
            case "*"
                if test -d "$dir"
                    cd $dir
                    return
                end
        end
    end
end