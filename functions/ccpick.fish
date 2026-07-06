# ccpick — Claude Code セッションを「プロジェクト(dir)」単位で一覧し、
# fzf で選んで attach / 起動 / 終了する。nvim 版(claude_tasks.lua)と
# ソケット命名・履歴ファイルを共有するので、相互に attach できる。
#
#   * タスク = ディレクトリ（claude はプロジェクト dir で動くもの）
#   * 一覧 = 自前履歴 + ~/.claude.json の projects を統合（実在 dir のみ）
#   * 稼働判定 = dtach ソケット存在 ＆ pgrep -f <sock>（● 稼働 / ○ 停止）
#
# fzf 内のキー操作:
#   Enter : 稼働中→attach / 停止中→起動（過去ログあれば --continue）
#   C-x   : 正常終了。/exit を送って claude に状態保存させる（resume 可能）
#   M-k   : 強制 kill（応答しないとき。状態保存は期待できない）
#
# 永続化は dtach。fish を閉じても claude は dtach デーモン下で生き残る。
# デタッチは dtach 既定の Ctrl-\。
#
# 関連ヘルパ(いずれも functions/ に分割配置＝fzf の fish -c から autoload 可能):
#   __ccpick_projects / __ccpick_sock / __ccpick_list / __ccpick_exit / __ccpick_kill

function ccpick --description "Claude セッションを一覧(稼働状態)から選んで attach/起動/終了 (fzf)"
    if not command -q dtach
        echo "dtach が必要です: sudo apt install dtach" >&2
        return 1
    end
    if not command -q fzf
        echo "fzf が必要です" >&2
        return 1
    end

    set -l data_dir ~/.cache/claude-tasks
    set -l claude (command -v claude); or set -l claude claude

    # 一覧(●/○ + 表示パス + フルパス)を fzf へ。C-x=正常終了 / M-k=強制kill は
    # 対象 dir({3}) にヘルパを実行してから reload で稼働状態を更新する。
    set -l chosen (
        __ccpick_list | fzf --no-sort --delimiter \t --with-nth 1,2 \
            --prompt 'Claude> ' \
            --header '● 稼働 / ○ 停止   Enter:開く  C-x:正常終了(resume可)  M-k:強制kill' \
            --preview 'fish -c "__ccpick_preview {3}"' \
            --preview-window 'down,55%,wrap' \
            --bind 'ctrl-x:execute-silent(fish -c "__ccpick_exit {3}")+reload(fish -c __ccpick_list)' \
            --bind 'alt-k:execute-silent(fish -c "__ccpick_kill {3}")+reload(fish -c __ccpick_list)'
    )
    test -z "$chosen"; and return 0
    set -l dir (string split -f3 \t -- $chosen)
    test -z "$dir"; and return 0

    # 履歴の先頭へ（重複排除）
    mkdir -p $data_dir
    begin
        echo $dir
        if test -r "$data_dir/projects"
            for d in (cat "$data_dir/projects")
                set d (string trim -- $d)
                if test -n "$d"; and test "$d" != "$dir"
                    echo $d
                end
            end
        end
    end >"$data_dir/projects.tmp"
    and mv "$data_dir/projects.tmp" "$data_dir/projects"

    set -l sock (__ccpick_sock $dir)

    # stale ソケット掃除（プロセスが居ないのにソケットだけ残っている場合）
    if test -e "$sock"; and not pgrep -f "$sock" >/dev/null 2>&1
        rm -f "$sock"
    end

    # 過去会話ログがあれば --continue で前回を継続
    set -l enc (string replace -ra '[^A-Za-z0-9]' '-' -- $dir)
    set -l cont
    if test -d ~/.claude/projects/$enc
        set -l js (find ~/.claude/projects/$enc -maxdepth 1 -name '*.jsonl' 2>/dev/null)
        test -n "$js"; and set cont --continue
    end

    # dtach -A: 稼働中なら attach、無ければ dir を cwd にして起動
    cd $dir; or return 1
    dtach -A $sock $claude $cont
end
