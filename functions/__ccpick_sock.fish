# dir → dtach ソケットパス。nvim 版(vim.fn.sha256(dir):sub(1,16)) と同一命名で
# セッションを共有できる。
function __ccpick_sock --description "dir から dtach ソケットパスを算出"
    set -l h (printf '%s' $argv[1] | sha256sum | string sub -l 16)
    echo $HOME/.cache/claude-tasks/$h.sock
end
