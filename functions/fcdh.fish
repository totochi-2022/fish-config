function fcdh -d "Change directory from home with fzf"
    set -l dir (find ~ -type d | fzf --preview 'eza --tree --level=2 --color=always {}')
    if test -n "$dir"
        cd $dir
    end
end