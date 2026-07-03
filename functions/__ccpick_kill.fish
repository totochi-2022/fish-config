# Claude セッションを強制終了（応答しなくなったとき用・最終手段）。
# dtach マスタを kill するので claude は SIGHUP で落ち、状態保存は期待できない。
# 正常に終わらせたいときは __ccpick_exit を使うこと。
function __ccpick_kill --description "Claude セッションを強制 kill(状態保存なし)"
    set -l dir $argv[1]
    test -z "$dir"; and return
    set -l sock (__ccpick_sock $dir)
    pkill -f "$sock" 2>/dev/null
    rm -f "$sock"
end
