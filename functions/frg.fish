function frg -d "Search content with ripgrep and fzf - interactive mode switcher"
    set -l mode "current"
    set -l search_path "."
    set -l query ""
    
    if test (count $argv) -gt 0
        set query $argv[1]
    end
    
    while true
        switch $mode
            case "current"
                set -l header "Current Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set search_path "."
                
            case "home"
                set -l header "Home Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set search_path "~"
                
            case "root"
                set -l header "Root Directory Mode | Press H:Home R:Root C:Current Q:Quit"
                set search_path "/"
        end
        
        set -l rg_cmd
        if test "$mode" = "root"
            set rg_cmd "rg --color=always --line-number --no-heading --smart-case --hidden '$query' $search_path --glob '!proc/*' --glob '!sys/*' --glob '!dev/*' --glob '!mnt/*' --glob '!snap/*' --glob '!tmp/*' 2>/dev/null"
        else
            set rg_cmd "rg --color=always --line-number --no-heading --smart-case --hidden '$query' $search_path"
        end
        
        set -l result (eval $rg_cmd | fzf --ansi --header="$header" --bind="h:execute(echo home)+abort,r:execute(echo root)+abort,c:execute(echo current)+abort,q:abort" --delimiter : --preview 'bat --color=always --style=numbers --line-range={2}: {1}' --preview-window '+{2}-/2' --bind 'enter:execute(echo "file:{1}:{2}")+abort')
        
        if test -z "$result"
            return
        end
        
        switch $result
            case "home"
                set mode "home"
            case "root"
                set mode "root"
            case "current"
                set mode "current"
            case "file:*"
                set -l file_info (string split ":" $result)
                set -l file_path $file_info[2]
                set -l line_num $file_info[3]
                if test -f "$file_path"
                    nvim $file_path +$line_num
                    return
                end
        end
    end
end