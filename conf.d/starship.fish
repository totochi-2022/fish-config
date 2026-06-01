# Starship設定（他の設定の後に読み込まれるようにする）
if command -q starship
    starship init fish | source

    # transient prompt: 実行後の過去プロンプトを character(❯) だけに簡略化
    # 左=character のみ / 右=空 になり、過去ログにはコマンドだけが残る
    function starship_transient_prompt_func
        starship module character
    end
    enable_transience
end