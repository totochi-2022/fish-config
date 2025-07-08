function fcdr -d "Change directory from root with fzf"
    set -l dir (find / -type d -not -path '/proc/*' -not -path '/sys/*' -not -path '/dev/*' -not -path '/mnt/*' -not -path '/snap/*' -not -path '/tmp/*' 2>/dev/null | fzf --preview 'eza --tree --level=2 --color=always {}')
    if test -n "$dir"
        cd $dir
    end
end