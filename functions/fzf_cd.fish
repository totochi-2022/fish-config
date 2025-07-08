function fzf_cd -d "Change directory with fzf"
    set -l dir (find . -type d -not -path '*/.*' | fzf --preview 'eza --tree --level=2 --color=always {}')
    if test -n "$dir"
        cd $dir
    end
end