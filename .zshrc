export LANG=ja_JP.UTF-8
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

#パスの設定
PATH=/usr/local/bin:$PATH
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias git='nocorrect git'

## 補完機能の強化
autoload -Uz compinit
compinit

autoload colors
colors
case ${UID} in
0)
  PROMPT="%B%{${fg[white]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[white]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[white]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
*)
  PROMPT="%{${fg[white]}%}%/%%%{${reset_color}%} "
  PROMPT2="%{${fg[white]}%}%_%%%{${reset_color}%} "
  SPROMPT="%{${fg[white]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
esac

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
#setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## ヒストリを共有
setopt share_history

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# 色有効
autoload -U colors
colors

# 色を定義
local GREEN=$'%{\e[1;32m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'

# 通常のプロンプト
PROMPT=$BLUE'[%n]%# '$WHITE
# 右側のプロンプト。ここでカレントディレクトリを出す。
RPROMPT=$GREEN'[%~]'$WHITE
setopt transient_rprompt

## スペルチェック
setopt correct

# vcs_infoロード
autoload -Uz vcs_info
# PROMPT変数内で変数参照する
setopt prompt_subst

# vcsの表示
zstyle ':vcs_info:*' formats '%s][* %F{green}%b%f'
zstyle ':vcs_info:*' actionformats '%s][* %F{green}%b%f(%F{red}%a%f)'
# プロンプト表示直前にvcs_info呼び出し
precmd() { vcs_info }
# プロンプト表示
PROMPT='[${vcs_info_msg_0_}]:%~/%f '

alias t="tig"
alias la="ls -a"
alias ll="ls -l"
alias g="git"
alias st="C:/Program\ Files/Sublime\ Text\ 3/sublime_text.exe"
export TMUX_TMPDIR=/var/run/tmux
