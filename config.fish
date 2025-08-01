# Fishの起動メッセージを非表示
set fish_greeting ""

# PATH設定を最初に実行
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/mise/shims
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.claude_plugin/scripts

if status is-interactive
    # Commands to run in interactive sessions can go here

    # mise設定（インストールされている場合のみ）
    if command -q mise
        mise activate fish | source
        mise completions fish | source
    end

    # starship設定（インストールされている場合のみ）
    if command -q starship
        starship init fish | source
    end

    # ls関係のエイリアス（mise activateの後に配置）
    alias ls="eza --group-directories-first -F"
    alias lsm="eza --sort=modified --group-directories-first -rF"
    alias l="eza --group-directories-first -F"
    alias lm="eza --sort=modified --group-directories-first -rF"
    alias ll="eza -alF --group-directories-first --icons"
    alias llm="eza -alrF --sort=modified --group-directories-first --icons"
    alias llf="eza -alTL --icons"
    alias la="eza -AF --group-directories-first"
    alias lam="eza -ArF --sort=modified --group-directories-first"

    # その他のエイリアス
    alias killcad="taskkill.exe /F /IM LibreCAD.exe"
    alias psh="/mnt/c/'Program\ Files'/PowerShell/7/pw:sh.exe"
    alias cat="bat:"
    abbr s sudo
    alias win="wslview"
    alias b="bd -i"
    abbr vi nvim
    abbr sof "source ~/.config/fish/config.fish"
    abbr tl "tldr -L ja"

    # FZF + ripgrep エイリアス
    alias frg="fzf_rg"
    alias fgf="fzf_git_files"
    alias fgl="fzf_git_log"
    alias fcd="fzf_cd"

    # 環境変数設定
    set -gx GHQ_SELECTOR peco
    set -gx BROWSER "pwsh.exe /c start"
    set -gx EZA_OPTIONS "--icons --group-directories-first --git"
    set -gx EZA_COLORS "di=36:da=36"
    set -gx EDITOR nvim
    set -gx SUDO_EDITOR nvim
    set -gx VISUAL nvim
    set -gx TEALDEER_LANGUAGE ja
    set -gx CLAUDE_CODE_AUTO_UPDATE false

    # .NET設定
    set -gx DOTNET_ROOT ~/.local/share/mise/installs/dotnet-core/8.0.412
    set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

    # FZF設定
    set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --bind ctrl-a:select-all,ctrl-d:deselect-all'
    set -gx FZF_CTRL_T_OPTS '--preview "bat --color=always --style=numbers --line-range=:500 {}"'

    # コンテキスト対応ヘルプ表示
    bind \ch show_context_help
    
    # Fuzzy selector
    bind \cv fs

    # zプラグインをjでも使用可能に（pwd出力付き）
    abbr j zp
    abbr z zp
end

# 関数定義
# Windows側のmiseを一時的に無効化
function mise_win_off
    set -gx PATH (string match -v "/mnt/c/*" $PATH)
    echo "Windows PATH disabled. Current mise:"
    which mise
end

# Windows側のmiseを再有効化
function mise_win_on
    source ~/.config/fish/config.fish
    echo "Windows PATH re-enabled"
end

# 既存の cd 関数が定義されているか確認してから定義する
if not functions -q standard_cd
    functions --copy cd standard_cd
end

# cd 関数を上書き
function cd --wraps cd
    standard_cd $argv; and eza -F
end

function tabe
    set windows_path ""
    if test (count $argv) -eq 0
        # 引数なしの場合、カレントディレクトリを開く
        set windows_path (wslpath -w (pwd))
    else
        set input_path $argv[1]
        if string match -q / $input_path
            # 絶対パスの場合
            set windows_path (wslpath -w $input_path)
        else
            # 相対パスの場合
            set windows_path (wslpath -w (realpath $input_path))
        end
    end

    "/mnt/c/bin/te/TE64.exe" $windows_path
end

# zプラグイン拡張関数
function zp -d "z with pwd and ls output"
    set target (__z -e $argv)
    and standard_cd "$target"
    and pwd
    and ls -F
end

# zp関数の補完設定
complete -c zp -a "(__z -l | string replace -r '^\\S*\\s*' '')" -f -k
set -x PATH $HOME/.local/share/gem/ruby/3.4.0/bin $PATH
