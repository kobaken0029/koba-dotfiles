set nocompatible
set number
set backspace=2
set nobackup

"-------Search--------
"インクリメンタルサーチを有効にする
set incsearch

"大文字小文字を区別しない
set ignorecase

"大文字で検索されたら対象を大文字限定にする
set smartcase

"行末まで検索したら行頭に戻る
set wrapscan

"-------Format--------
"自動インデントを有効化する
set smartindent
set autoindent

"フォーマット揃えをコメント以外有効にする
set formatoptions-=c

"括弧の対応をハイライト
set showmatch

"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする。
set smarttab

" インデントをスペース4つにする
set tabstop=4
set expandtab
set shiftwidth=4

noremap!  
:syntax on


if executable('indent')
  let s:indent_cmd = 'indent -orig -bad -bap -nbbb -nbbo -nbc -bli0 -br -brs -nbs
        \ -c8 -cbiSHIFTWIDTH -cd8 -cdb -cdw -ce -ciSHIFTWIDTH -cliSHIFTWIDTH -cp2 -cs
        \ -d0 -nbfda -nbfde -di0 -nfc1 -nfca -hnl -iSHIFTWIDTH -ipSHIFTWIDTH
        \ -nlp -lps -npcs -piSHIFTWIDTH -nprs -psl -saf -sai -saw -sbi0
        \ -sc -nsob -nss -tsSOFTTABSTOP -ppiSHIFTWIDTH -ip0 -l160 -lc160'
  function! s:format_c_program(has_bang) abort range
    let indent_cmd = substitute(s:indent_cmd, 'SHIFTWIDTH', &sw, 'g')
    let indent_cmd = substitute(indent_cmd, 'SOFTTABSTOP', &sts, 'g')
    let indent_cmd .= &expandtab ? ' -nut' : ' -ut'
    execute 'silent' a:firstline ',' a:lastline '!' indent_cmd
    if !v:shell_error || a:has_bang
      return
    endif
    " 以下，エラーが発生したとき用の処理
    let current_file = expand('%')
    if current_file ==# ''
      let current_file = '[No Name]'
    endif
    " カレントバッファにぶちまけられたエラーメッセージを取得
    let error_lines = filter(getline('1', '$'), 'v:val =~# "^indent: Standard input:\\d\\+: Error:"')
    " 'Standard input'を現在のファイル名に置き換えたり，範囲指定している場合のために，行番号を置き換えたりする
    let error_lines = map(error_lines, 'substitute(v:val, "^indent: \\zsStandard input:\\(\\d\\+\\)\\ze: Error:", "\\=current_file . \":\" . (submatch(1) + a:firstline - 1)", "")')
    let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
    " カレントバッファをエラーメッセージがぶちまけられる前の状態に戻す
    undo
    " カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
    execute 'botright' winheight 'split [INDENT_ERROR]'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    call setline(1, error_lines)
    " エラー表示用のundo履歴を消去する（誤ってundoでエラー情報を消去しないため）
    let save_undolevels = &l:undolevels
    setlocal undolevels=-1
    execute "normal! a \<BS>\<Esc>"
    setlocal nomodified
    let &l:undolevels = save_undolevels
    " エラーメッセージ用バッファは読み取り専用にしておく
    setlocal readonly
  endfunction
  augroup CFormat
    autocmd!
    autocmd FileType c,cpp
          \ command! -bar -bang -range=% -buffer FormatCProgram
          \ <line1>,<line2>call s:format_c_program(<bang>0)
  augroup END
endif

