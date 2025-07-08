# CLAUDE.md

このファイルは、このリポジトリでコードを作業する際のClaude Code (claude.ai/code) 向けのガイダンスを提供します。

## 概要

これは包括的な設定を持つFishシェル設定ディレクトリで、プラグイン、カスタム関数、テーマが含まれています。設定はFisherをプラグインマネージャーとして使用し、さまざまな生産性向上ツールを含んでいます。

## プラグイン管理

### Fisherコマンド
- `fisher install <plugin>` - 新しいプラグインをインストール
- `fisher remove <plugin>` - インストール済みプラグインを削除
- `fisher update` - すべてのインストール済みプラグインを更新
- `fisher list` - インストール済みプラグインをリスト表示

### インストール済みプラグイン
設定には以下のプラグインが含まれています（`fish_plugins`で定義）：
- `jorgebucaran/fisher` - プラグインマネージャー
- `jorgebucaran/nvm.fish` - Nodeバージョンマネージャー
- `franciscolourenco/done` - コマンド完了通知
- `0rax/fish-bd` - 素早い親ディレクトリナビゲーション
- `oh-my-fish/plugin-extract` - アーカイブ展開ユーティリティ
- `oh-my-fish/plugin-bang-bang` - Bash風の`!!`コマンド繰り返し
- `jethrokuan/z` - 頻度に基づくディレクトリジャンプ
- `starship/starship` - クロスシェルプロンプト
- `patrickf1/fzf.fish` - ファジーファインダー統合

## 主要な関数とコマンド

### ナビゲーション
- `bd <directory>` - パターンに一致する親ディレクトリに戻る
  - `bd -s <pattern>` - パターンで始まるディレクトリをマッチ
  - `bd -i <pattern>` - 大文字小文字を区別しないマッチング
- `z <directory>` - 頻繁に使用するディレクトリにジャンプ
- **FZFバインディング** - さまざまなファジー検索操作用に設定済み

### ユーティリティ
- `extract <archive>` - さまざまなアーカイブ形式を展開（tar、zip、rarなど）
- `nvm` - Nodeバージョン管理コマンド

### プロンプト機能
- **左プロンプト**: 現在のディレクトリを表示、リモート時はSSHユーザー情報も表示
- **右プロンプト**: 詳細な情報を含むGitステータスを表示：
  - ブランチ名とステータス
  - コミットの先行/遅れインジケーター
  - ファイル修正ステータス（追加、削除、変更、名前変更、未追跡）
  - スタッシュステータス
  - コマンド終了ステータス

## アーキテクチャ

### 設定構造
- `config.fish` - PATH設定とツール初期化を含むメイン設定ファイル
- `functions/` - カスタムFish関数とプラグイン関数
- `conf.d/` - 自動的に読み込まれる設定スニペット
- `completions/` - コマンド補完定義
- `themes/` - テーマファイル（存在する場合）

### 主要な設定要素
- **Mise統合**: ランタイムバージョン管理（`mise activate fish`）
- **Starshipプロンプト**: Git統合付きクロスシェルプロンプト
- **Done通知**: 長時間実行されるコマンドのデスクトップ通知
- **FZF統合**: ファイル、ディレクトリ、Git操作などのファジーファインダー

### 開発ツール統合
- nvm.fishを通じたNode.jsバージョン管理
- 詳細なプロンプトとFZF統合によるGitワークフロー拡張
- extract関数によるアーカイブ処理
- 長時間実行操作のコマンド完了通知

## 設定ファイル

### メインファイル
- `config.fish` - 主要設定と初期化
- `fish_plugins` - Fisherプラグインリスト
- `fish_variables` - Fishシェル変数ストレージ

### 関数カテゴリ
- ナビゲーション: `bd.fish`、`__z*.fish`関数
- Git統合: 包括的なGitステータスを持つ`fish_right_prompt.fish`
- パッケージ管理: `fisher.fish`、`nvm.fish`
- 生産性: `extract.fish`、FZF関連関数
- プロンプト: `fish_prompt.fish`、`fish_right_prompt.fish`

## 環境設定

この設定は以下を前提としています：
- プライマリシェルとしてのFishシェル
- Gitのインストールと設定
- ランタイム管理のためのmise（旧rtx）
- Starshipプロンプトのインストール
- ファジーファインダーのためのFZFのインストール
- 展開機能のためのさまざまなアーカイブツール（tar、zip、unrarなど）
