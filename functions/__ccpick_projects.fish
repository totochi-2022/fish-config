# 実在する Claude プロジェクト dir を「最終利用時刻の新しい順」で列挙。
# 自前履歴(~/.cache/claude-tasks/projects) と ~/.claude.json の projects を統合する。
function __ccpick_projects --description "Claude プロジェクト dir を最終利用順で列挙"
    set -l data_dir ~/.cache/claude-tasks
    set -l seen
    set -l dirs

    # 自前履歴（最近順）
    if test -r "$data_dir/projects"
        for d in (cat "$data_dir/projects")
            set d (string trim -- $d)
            if test -n "$d"; and test -d "$d"; and not contains -- $d $seen
                set -a seen $d
                set -a dirs $d
            end
        end
    end

    # claude-code 自身が記録している過去プロジェクト
    if test -r ~/.claude.json; and command -q jq
        for d in (jq -r '.projects | keys[]?' ~/.claude.json 2>/dev/null)
            if test -d "$d"; and not contains -- $d $seen
                set -a seen $d
                set -a dirs $d
            end
        end
    end

    # ~/.claude/projects/<enc> の mtime を最終利用時刻として降順ソート
    begin
        for d in $dirs
            set -l enc (string replace -ra '[^A-Za-z0-9]' '-' -- $d)
            set -l t 0
            if test -d ~/.claude/projects/$enc
                set t (stat -c %Y ~/.claude/projects/$enc 2>/dev/null)
            end
            test -z "$t"; and set t 0
            printf '%s\t%s\n' $t $d
        end
    end | sort -rn | cut -f2-
end
