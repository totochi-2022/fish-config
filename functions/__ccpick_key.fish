# ccpick をキーバインドから起動するためのラッパ。
# コマンドラインに `ccpick` を置いて execute することで、
# フルスクリーンの claude(dtach) に端末を綺麗に引き渡す（入力途中の行があれば置換される）。
function __ccpick_key --description "ccpick をキーバインドから起動"
    commandline -r ccpick
    commandline -f execute
end
