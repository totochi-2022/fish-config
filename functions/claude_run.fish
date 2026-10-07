function claude_run -d "claude -p を非対話で実行する（ツール許可つき）"
    # 使い方:
    #   claude_run "プロンプト"
    #   claude_run "プロンプト" --model claude-sonnet-5-5   # claude のオプションも後ろに足せる
    #   cat error.log | claude_run "原因を3行で"            # 標準入力も渡せる
    #   fish -c 'claude_run "..."'                          # cron からはこの形
    #
    # ★ ANTHROPIC_API_KEY を必ず外すこと。
    #   環境に生きていない API キーが入っていると claude が **無言でタイムアウト**する
    #   （2026-10-07 に 2 回踏んだ）。外すと claude.ai ログイン
    #   （~/.claude/.credentials.json / Team プラン）で動く。
    #
    # ★ --allowedTools を付けないと、非対話では権限確認が出た時点で固まる。

    if test (count $argv) -eq 0
        echo "使い方: claude_run \"プロンプト\" [claude のオプション...]" >&2
        return 2
    end

    env -u ANTHROPIC_API_KEY claude -p $argv \
        --allowedTools "Bash,Read,Write" \
        --permission-mode acceptEdits
end
