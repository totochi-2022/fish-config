function show_context_help
    set current_cmd (commandline -t)
    
    # コマンドの最初の単語を取得
    set cmd_word (string split ' ' $current_cmd)[1]
    
    switch $cmd_word
        case 'npm'
            echo "【npm】install uninstall update list search init run build test"
            echo "【よく使う】npm i <pkg> | npm run dev | npm update"
            
        case 'pip'
            echo "【pip】install uninstall upgrade list search freeze show"
            echo "【よく使う】pip install <pkg> | pip freeze > requirements.txt"
            
        case 'apt'
            echo "【apt】install remove update upgrade search list autoremove"
            echo "【よく使う】sudo apt update && sudo apt upgrade"
            
        case 'git'
            echo "【git】add commit push pull status log branch checkout merge"
            echo "【よく使う】git add . | git commit -m | git push origin"
            
        case 'mise'
            echo "【mise】install uninstall update list search use current"
            echo "【よく使う】mise install node@20 | mise use node@20"
            
        case 'gem'
            echo "【gem】install uninstall update list search"
            echo "【よく使う】gem install <gem> | gem list"
            
        case 'yarn'
            echo "【yarn】add remove install upgrade list run build"
            echo "【よく使う】yarn add <pkg> | yarn dev | yarn build"
            
        case 'pnpm'
            echo "【pnpm】add remove install update list run build"
            echo "【よく使う】pnpm add <pkg> | pnpm dev | pnpm build"
            
        case '*'
            echo "【移動】Ctrl+A:先頭 Ctrl+E:末尾 Alt+F:単語前 Alt+B:単語後"
            echo "【削除】Ctrl+U:行頭まで Ctrl+K:行末まで Ctrl+W:単語削除"
    end
    
    echo "(何かキーを押してください...)"
    read -n 1
    clear
    commandline -f repaint
end