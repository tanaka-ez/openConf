###################
### interesting ###
###################

function talk(){
  echo "Please input your ssh user name:";
  read INPUT_SSH_ACOUNT
  echo "Hi $INPUT_SSH_ACOUNT!!"
  echo 'Please input ssh host:'
  read INPUT_SSH_HOST

  case $INPUT_SSH_HOST in
    JUMP)
      ssh $INPUT_SSH_ACOUNT@$PROJECT_JUMP_HOST
    ;;

    STG)
      echo "ssh "${INPUT_SSH_ACOUNT}@${PROJECT_STG_HOST}|tr -d '\n'|pbcopy
      echo 'stg ssh command copy dane!!'
      ssh $INPUT_SSH_ACOUNT@$PROJECT_JUMP_HOST
    ;;
  esac
}

################
### autoload ###
################

#色
autoload -U colors && colors

#補完機能
autoload -U compinit && compinit

#################
###  環境変数  ###
#################

##################
###     色     ###
##################

#色見本表示
#for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo

################
### PROMPT ###
################

#PROMPT
#PROMPT="[%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg_no_bold[yellow]%}%1~%{$reset_color%}]%# "
PROMPT="[%F{175}%n%f@%F{079}%m%f %F{226}%1~%f]%F{165}%#%f "

#RPROMPTにブランチ名を表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{156}%1v%f|)"

################
### 基本設定 ###
################

#rbenv
#export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"

#cdr
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

#シンタックスに色
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

#補完機能の選択
zstyle ':completion:*:default' menu select=2

#大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

################
###  alias   ###
################

#my add alias
alias projectCdGit='cd ~/vagrant/develop/system'

alias projectCdGrunt='cd ~/vagrant/develop/system/project/cssbuild/frontend'

alias ll='ls -lrt'

alias projectGrunt=projectGrunt

alias projectSymfonyCc='php ~/vagrant/develop/system/project/symfony cc'

##################
###  function  ###
##################

function projectMysqlLogin(){
  ssh PROJECT_JUMP_HOST_USER@$PROJECT_JUMP_HOST
}

function projectGrunt(){
  projectCdGrunt
  grunt
  cd -
}

function zshrcSave(){
  FILE_DATE=`date "+%Y%m%d-%H%M%S"`
  cp ~/.zshrc ~/.zshrc_${FILE_DATE}
}

###################
##    履歴保存    ##
##################

HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する
setopt hist_ignore_dups               # 直前と同じコマンドをヒストリに追加しない
setopt hist_expire_dups_first         # 重複を優先して削除

################
##    PECO    ##
################

function peco-select-history() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history



