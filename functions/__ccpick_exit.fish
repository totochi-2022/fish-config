# Claude セッションを正常終了する（resume 可能な形）。
# dtach -p でセッションの pty に入力を流し込み、claude 自身に /exit させて
# 状態を保存させる。dtach マスタを kill すると claude が SIGHUP で強制終了し
# 会話が保存されず resume が効かなくなるため、それは __ccpick_kill に分ける。
function __ccpick_exit --description "Claude セッションを /exit で正常終了(resume可)"
    set -l dir $argv[1]
    test -z "$dir"; and return
    set -l sock (__ccpick_sock $dir)

    # 稼働していなければ stale ソケットを掃除するだけ
    if not begin
            test -e "$sock"; and pgrep -f "$sock" >/dev/null 2>&1
        end
        test -e "$sock"; and rm -f "$sock"
        return 0
    end

    # ESC で生成中断/入力クリア → 少し待って /exit を送信 → 保存して抜けるのを待つ
    printf '\e' | dtach -p "$sock"
    sleep 0.2
    printf '/exit\r' | dtach -p "$sock"
    sleep 1.2
end
