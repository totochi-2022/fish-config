# ccpick — Claude Code セッションを fzf で選んで attach/起動/終了する fish UI。
#
# ロジック(一覧/preview/稼働判定/exit/kill/履歴)は claude-plugin-system の
# `claude-tasks`(PATH, ~/.claude_plugin/scripts) に集約されており、ここは
# fzf の見た目と「端末で開く/attach」という fish 固有部分だけを持つ。
# nvim(claude_tasks.lua)も同じ claude-tasks を叩くので、Claude 仕様変更時は
# claude-tasks 1 箇所を直せば両方追従する。
#
# fzf 内のキー操作:
#   Enter : 稼働中→attach / 停止中→起動(過去ログあれば --continue)
#   C-x   : 正常終了(/exit を送って保存。resume 可能)
#   M-k   : 強制 kill(応答しないとき)
# デタッチは dtach 既定の Ctrl-\。

function ccpick --description "Claude セッションを一覧(稼働状態)から選んで attach/起動/終了 (fzf)"
    if not command -q dtach
        echo "dtach が必要です: sudo apt install dtach" >&2
        return 1
    end
    if not command -q fzf
        echo "fzf が必要です" >&2
        return 1
    end
    if not command -q claude-tasks
        echo "claude-tasks が PATH に必要です (~/.claude_plugin/scripts)" >&2
        return 1
    end

    # 一覧(●/○ + 表示パス + フルパス)を fzf へ。preview/exit/kill/reload は
    # すべて claude-tasks に委譲する({3}=フルパス)。
    set -l chosen (
        claude-tasks list | fzf --no-sort --delimiter \t --with-nth 1,2 \
            --prompt 'Claude> ' \
            --header '● 稼働 / ○ 停止   Enter:開く  C-x:正常終了(resume可)  M-k:強制kill' \
            --preview 'claude-tasks preview {3}' \
            --preview-window 'down,55%,wrap' \
            --bind 'ctrl-x:execute-silent(claude-tasks exit {3})+reload(claude-tasks list)' \
            --bind 'alt-k:execute-silent(claude-tasks kill {3})+reload(claude-tasks list)'
    )
    test -z "$chosen"; and return 0
    set -l dir (string split -f3 \t -- $chosen)
    test -z "$dir"; and return 0

    claude-tasks add-history $dir

    # stale ソケット掃除(プロセスが居ないのにソケットだけ残っている場合)
    set -l sock (claude-tasks sock $dir)
    if not claude-tasks is-live $dir; and test -e "$sock"
        rm -f "$sock"
    end

    # 過去会話ログがあれば --continue で前回を継続
    set -l cont
    claude-tasks needs-continue $dir; and set cont --continue

    # dtach -A: 稼働中なら attach、無ければ dir を cwd にして起動(この部分は fish 固有)
    cd $dir; or return 1
    dtach -A $sock (command -v claude) $cont
end
