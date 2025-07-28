function zp -d "z with pwd and ls output"
    set target (__z -e $argv)
    and standard_cd "$target"
    and pwd
    and eza -F
end