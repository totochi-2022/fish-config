# Starship設定（他の設定の後に読み込まれるようにする）
if command -q starship
    starship init fish | source
end