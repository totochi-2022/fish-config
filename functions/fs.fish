function fs -d "Fuzzy selector for various search types"
    set -l options "File/Directory Search" "Process Search" "Git Status" "Git Log" "History Search" "Variables" "Custom: fzf_cd" "Custom: fzf_git_files" "Custom: fzf_git_log" "Custom: fzf_rg (current)" "Custom: fzf_rg_home" "Custom: fzf_rg_root"
    
    set -l choice (printf '%s\n' $options | fzf --prompt="Select search type > ")
    
    switch "$choice"
        case "File/Directory Search"
            _fzf_search_directory
        case "Process Search" 
            _fzf_search_processes
        case "Git Status"
            _fzf_search_git_status
        case "Git Log"
            _fzf_search_git_log
        case "History Search"
            _fzf_search_history  
        case "Variables"
            _fzf_search_variables (set --show | psub) (set --names | psub)
        case "Custom: fzf_cd"
            fzf_cd
        case "Custom: fzf_git_files"
            fzf_git_files
        case "Custom: fzf_git_log"
            fzf_git_log
        case "Custom: fzf_rg (current)"
            fzf_rg
        case "Custom: fzf_rg_home"
            fzf_rg_home
        case "Custom: fzf_rg_root"
            fzf_rg_root
    end
end