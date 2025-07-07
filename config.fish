if status is-interactive
    set -x PATH $HOME/.local/bin $PATH
    # Commands to run in interactive sessions can go here
    mise activate fish | source
    starship init fish | source
end
