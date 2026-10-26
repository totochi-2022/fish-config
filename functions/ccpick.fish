# ccpick — Claude Code セッションを fzf で選んで attach/起動/終了する。
#
# 画面もロジックも claude-plugin-system の `claude-tasks pick`(Python)にある。ここは
# 「開いたフォルダへ cd する」ことだけを受け持つ(子プロセスからは親シェルの cwd を変えられないため、
# pick が CCPICK_CD_FILE に書いたフォルダへ移る)。キー操作は claude-tasks pick の説明を参照。
# デタッチは dtach 既定の Ctrl-\。

function ccpick --description "Claude セッションを一覧(稼働状態)から選んで attach/起動/終了 (fzf)"
    if not command -q claude-tasks
        echo "claude-tasks が PATH に必要です (~/.claude_plugin/scripts)" >&2
        return 1
    end
    set -l f (mktemp)
    CCPICK_CD_FILE=$f claude-tasks pick
    set -l st $status
    set -l d (cat $f 2>/dev/null)
    rm -f $f
    test -n "$d"; and cd $d
    return $st
end
