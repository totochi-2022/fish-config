#\!/usr/bin/env fish

echo "🐟 Fish設定セットアップを開始..."

# 1. Fisherのインストール（未インストールの場合）
if not functions -q fisher
    echo "📦 Fisherをインストール中..."
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    and fisher install jorgebucaran/fisher
end

# 2. プラグインの一括インストール
echo "📦 プラグインをインストール中..."
fisher update

# 3. 必要なツールの確認
echo "🔍 必要なツールを確認中..."

# starship
if not command -q starship
    echo "⚠️  starshipが見つかりません。インストールしてください："
    echo "   curl -sS https://starship.rs/install.sh | sh"
end

# eza
if not command -q eza
    echo "⚠️  ezaが見つかりません。インストールしてください："
    echo "   cargo install eza  # または apt install eza"
end

# bat
if not command -q bat
    echo "⚠️  batが見つかりません。インストールしてください："
    echo "   apt install bat"
end

# fzf
if not command -q fzf
    echo "⚠️  fzfが見つかりません。インストールしてください："
    echo "   apt install fzf"
end

# ripgrep
if not command -q rg
    echo "⚠️  ripgrepが見つかりません。インストールしてください："
    echo "   apt install ripgrep"
end

# 4. ローカル設定ファイルのテンプレート作成
if not test -f ~/.config/fish/config.local.fish
    echo "📝 ローカル設定ファイルを作成中..."
    echo "# ローカル設定（このPCのみ）
# 例: set -gx LOCAL_VAR value" > ~/.config/fish/config.local.fish
end

echo "✅ セットアップ完了！"
echo "🔄 設定を反映するには: source ~/.config/fish/config.fish"
