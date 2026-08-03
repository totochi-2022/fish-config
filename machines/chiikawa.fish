# chiikawa (WSL) 固有設定

# /mnt/box (Box Drive) が外れていたらシェル起動時に自動再マウント
# - Box Drive の再起動・自動更新で drvfs マウントが外れることがある
# - systemd の automount は WSL のセッション用マウント名前空間に伝播しないため、
#   シェル側で復旧する (sudo は NOPASSWD 前提)
if status is-interactive
    if not mountpoint -q /mnt/box
        if sudo mount /mnt/box 2>/dev/null
            echo "[info] /mnt/box を再マウントしました"
        else
            echo "[warn] /mnt/box をマウントできません (Box Drive が起動しているか確認)"
        end
    end
end

# USB-RS485 (FTDI 0403:6001) が未attachならWSLに自動attach
# - admin が要るのは初回の bind だけ(済み)。attach は非管理者で通る
# - --hardware-id 指定なので USB ポートを差し替えても busid 調べ直し不要
# - アダプタ未接続時は attach が失敗するだけ(無音)
if status is-interactive
    if not test -e /dev/ttyUSB0
        '/mnt/c/Program Files/usbipd-win/usbipd.exe' attach --wsl --hardware-id 0403:6001 >/dev/null 2>&1
        and echo "[info] USB-RS485 を WSL に attach しました (/dev/ttyUSB0)"
    end
end
