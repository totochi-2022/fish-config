# ccpick の preview: 選択中プロジェクトの「最新 Claude 会話」を読みやすく表示する。
# ~/.claude/projects/<enc>/*.jsonl の最新ファイルから user/assistant のテキストを抽出。
function __ccpick_preview --description "選択中プロジェクトの最新 Claude 会話を preview 表示"
    set -l dir $argv[1]
    test -z "$dir"; and return

    set -l enc (string replace -ra '[^A-Za-z0-9]' '-' -- $dir)
    set -l pdir ~/.claude/projects/$enc

    # 会話ログが無ければディレクトリ一覧にフォールバック
    if not test -d "$pdir"
        echo "（会話ログなし）  $dir"
        echo
        eza -alF --group-directories-first --icons "$dir" 2>/dev/null; or ls -la "$dir"
        return
    end
    set -l latest (ls -t $pdir/*.jsonl 2>/dev/null | head -1)
    if test -z "$latest"
        echo "（会話ログなし）  $dir"
        return
    end

    echo "── 最新会話: "(basename $latest)"  ("(date -r "$latest" '+%m/%d %H:%M')") ──"
    echo
    # user/assistant のテキストのみ抽出。tool_result 等の非テキストは除外。
    jq -r '
        select(.type=="user" or .type=="assistant")
        | (.message.content) as $c
        | (if ($c|type)=="string" then $c
           elif ($c|type)=="array" then ($c|map(select(.type=="text")|.text)|join("\n"))
           else "" end) as $t
        | select($t != null and ($t|length)>0)
        | (if .type=="user" then "▶ USER" else "◀ CLAUDE" end) + "\n" + $t + "\n"
    ' "$latest" 2>/dev/null | tail -n 120
end
