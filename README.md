# Fish Configuration

個人用のfish shell設定ファイル管理リポジトリです。

## 📁 ディレクトリ構成

```
fish/
├── config.fish           # メイン設定ファイル
├── fish_plugins          # Fisherプラグインリスト
├── functions/            # カスタム関数とプラグイン関数
├── completions/          # 補完設定
├── conf.d/              # 追加設定ファイル
├── machines/            # マシン別設定
│   └── totochi.fish     # 特定マシン用設定
├── themes/              # テーマファイル
├── setup.fish           # セットアップスクリプト
├── .gitignore           # Git除外設定
└── README.md            # このファイル
```

## 🚀 セットアップ

### 新しいPCでの初期設定

```bash
# 1. リポジトリをクローン
git clone git@github.com:totochi-2022/fish-config.git ~/work/repo/config/fish

# 2. 既存のfish設定をバックアップ（存在する場合）
mv ~/.config/fish ~/.config/fish.backup.$(date +%Y%m%d)

# 3. シンボリックリンクを作成
ln -s ~/work/repo/config/fish ~/.config/fish

# 4. セットアップスクリプトを実行
fish ~/.config/fish/setup.fish

# 5. 設定を反映
source ~/.config/fish/config.fish
```

## 📝 設定ファイルの管理方針

### Gitで管理するファイル

| ファイル/ディレクトリ | 説明 |
|----------------------|------|
| `config.fish` | メイン設定（全PC共通） |
| `fish_plugins` | Fisherプラグインリスト |
| `functions/` | すべての関数（自作＋プラグイン） |
| `completions/` | すべての補完設定 |
| `conf.d/` | すべての追加設定 |
| `machines/` | マシン別設定 |
| `setup.fish` | セットアップスクリプト |

### Gitで管理しないファイル（.gitignore）

| ファイル | 理由 |
|---------|------|
| `fish_variables` | 環境依存の変数（APIキー等）を含む |
| `fish_history` | コマンド履歴（プライバシー） |
| `config.local.fish` | PC固有のローカル設定 |

## 🖥️ 複数PC管理

### 設定の優先順位

1. **共通設定** (`config.fish`) - すべてのPCで共有
2. **マシン別設定** (`machines/$(hostname).fish`) - 特定マシン用、Gitで管理
3. **ローカル設定** (`config.local.fish`) - そのPCのみ、Gitで管理しない

### マシン別設定の作成

```bash
# 新しいマシン用の設定ファイルを作成
echo "# $(hostname)の設定" > ~/.config/fish/machines/$(hostname).fish

# 例：特定のPCだけPATHを追加
echo "fish_add_path /opt/local/bin" >> ~/.config/fish/machines/$(hostname).fish
```

### ローカル設定の使用例

```bash
# config.local.fish に記述（Gitで管理されない）
# APIキーなどの機密情報
set -gx OPENAI_API_KEY "sk-..."
set -gx AWS_SECRET_KEY "..."

# そのPCだけの特殊なPATH
fish_add_path /usr/local/cuda/bin
```

## 🔧 必要なツール

setup.fishで自動チェックされますが、以下のツールが必要です：

| ツール | インストール方法 |
|--------|--------------|
| starship | `curl -sS https://starship.rs/install.sh \| sh` |
| eza | `cargo install eza` または `apt install eza` |
| bat | `apt install bat` |
| fzf | `apt install fzf` |
| ripgrep | `apt install ripgrep` |
| mise | [mise公式サイト](https://mise.jdx.dev) |

## 📦 プラグイン管理

### プラグインの追加

```bash
# Fisherでプラグインをインストール
fisher install some/plugin

# fish_pluginsファイルが自動更新される
# 変更をコミット
git add fish_plugins
git commit -m "Add some/plugin"
git push
```

### プラグインの同期

```bash
# 他のPCで最新を取得
git pull

# プラグインを更新
fisher update
```

## 🐛 トラブルシューティング

### fish起動時にエラーが出る場合

1. **`set -f` エラー**: Fish 3.3.x用の修正済み
2. **mise completions エラー**: usage CLIが必要
   ```bash
   curl -fsSL https://usage.jdx.dev/install.sh | sh
   ```

### 設定が反映されない場合

```bash
# 設定を再読み込み
source ~/.config/fish/config.fish

# または新しいシェルを起動
exec fish
```

## 🔄 更新とメンテナンス

### 設定を更新した場合

```bash
# 変更をコミット
cd ~/work/repo/config/fish
git add .
git commit -m "Update fish config: 変更内容"
git push

# 他のPCで同期
git pull
fisher update  # プラグインも更新
```

### バックアップからの復元

```bash
# シンボリックリンクを削除
rm ~/.config/fish

# バックアップから復元
mv ~/.config/fish.backup.20250811 ~/.config/fish
```

## 📌 注意事項

- `fish_variables`にはAPIキーなどの機密情報が含まれるため、絶対にコミットしない
- 新しいプラグインを追加したら必ず`fish_plugins`をコミット
- PC固有の設定は`config.local.fish`または`machines/$(hostname).fish`に記述

## 🗂️ 関連リポジトリ

- [nvim-config](https://github.com/totochi-2022/nvim-config) - Neovim設定