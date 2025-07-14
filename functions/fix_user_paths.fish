function fix_user_paths --description "Fix hardcoded user paths in Fish configuration"
    # Get current user's home directory
    set -l current_home $HOME
    
    # Reset Z plugin data paths
    set -U Z_DATA $current_home/.local/share/z/data
    set -U Z_DATA_DIR $current_home/.local/share/z
    set -U Z_EXCLUDE "^$current_home\$"
    
    # Reset fish_user_paths to use current user's home
    set -e fish_user_paths
    fish_add_path $current_home/.claude_plugin/scripts
    fish_add_path $current_home/.cargo/bin
    fish_add_path $current_home/.local/share/mise/shims
    fish_add_path $current_home/.local/bin
    
    echo "Fixed user-specific paths for: $current_home"
end