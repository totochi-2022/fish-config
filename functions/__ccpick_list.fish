# ccpick 用の一覧行を出力: "<mark>\t<表示パス(~短縮)>\t<フルパス>"。
# fzf の初期ソース兼 reload コマンドとして使う(fish -c __ccpick_list)。
function __ccpick_list --description "ccpick 用の一覧行(mark/表示/フルパス)を出力"
    for d in (__ccpick_projects)
        set -l sock (__ccpick_sock $d)
        set -l mark ○
        if test -e "$sock"; and pgrep -f "$sock" >/dev/null 2>&1
            set mark ●
        end
        printf '%s\t%s\t%s\n' $mark (string replace -- $HOME '~' $d) $d
    end
end
