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

    # 一覧(●/○[+状態] + 表示パス + フルパス + id)を fzf へ。列: {3}=dir, {4}=id。
    # id は "" (主セッション) or "chat" (会話モード fork)。同フォルダ2個目は別行(id=chat)で出る。
    # C-f = その dir に会話モード(fork)を新規起動。preview/exit/kill は claude-tasks に委譲。
    set -l out (
        claude-tasks list | fzf --no-sort --delimiter \t --with-nth 1,2 \
            --height 100% \
            --expect=enter,ctrl-f,ctrl-w \
            --prompt 'Claude> ' \
            --header '● 稼働 / ○ 停止   Enter:開く  C-f:会話fork  C-w:worktree生成  M-m:結合  M-r:破棄  C-x:終了  M-k:kill' \
            --preview 'claude-tasks preview {3} {4}' \
            --preview-window 'down,65%,wrap' \
            --bind 'ctrl-x:execute-silent(claude-tasks exit {3} {4})+reload(claude-tasks list)' \
            --bind 'alt-k:execute-silent(claude-tasks kill {3} {4})+reload(claude-tasks list)' \
            --bind 'alt-m:execute(claude-tasks worktree-merge {3})+reload(claude-tasks list)' \
            --bind 'alt-r:execute-silent(claude-tasks worktree-discard {3})+reload(claude-tasks list)'
    )
    test -z "$out"; and return 0
    set -l key $out[1]
    set -l chosen $out[2]
    test -z "$chosen"; and return 0
    set -l dir (string split -f3 \t -- $chosen)
    set -l id (string split -f4 \t -- $chosen)
    test -z "$dir"; and return 0

    claude-tasks add-history $dir
    cd $dir; or return 1

    if test "$key" = ctrl-f
        # 会話モード: 同フォルダに fork セッションを新規起動(現会話を引き継いで独立)。
        # 空き slot を発番(N個まで並列可)。
        set -l slot (claude-tasks next-fork-slot $dir)
        if test -z "$slot"
            echo "会話モード: 空き slot がありません(同時数上限)" >&2
            return 1
        end
        set -l fsock (claude-tasks sock $dir $slot)
        dtach -A $fsock (command -v claude) --continue --fork-session
        return
    end

    if test "$key" = ctrl-w
        # 平行開発: worktree を git で明示生成(native --worktree は dtach 下で作られないため)。
        # 選択が worktree 行なら母艦を辿る。生成後、その worktree dir で普通にセッション起動。
        set -l repo $dir
        if string match -q '*/.claude/worktrees/*' -- $dir
            set repo (string replace -r '/\.claude/worktrees/.*' '' -- $dir)
        end
        set -l wt (claude-tasks worktree-create $repo)
        if test -z "$wt"
            echo "worktree 生成に失敗(git repo か? branch 衝突か?)" >&2
            return 1
        end
        claude-tasks add-history $wt
        cd $wt; or return 1
        dtach -A (claude-tasks sock $wt) (command -v claude)
        return
    end

    # 通常 attach。fork 行(id=chat)を選べばその fork ソケットへ。
    set -l sock (claude-tasks sock $dir $id)
    if not claude-tasks is-live $dir $id; and test -e "$sock"
        rm -f "$sock" # stale ソケット掃除
    end
    # 主セッションの新規起動時のみ過去ログを --continue(fork は fork起動側で扱う)
    set -l cont
    if test -z "$id"; and claude-tasks needs-continue $dir
        set cont --continue
    end
    dtach -A $sock (command -v claude) $cont
end
