# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "(${BRANCH}${STAT})"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}

export PS1="\u\w\`parse_git_branch\` "

source ~/.git-prompt.sh
PS1="\[\e[0;34m\]\w\[\e[0m\]\[\e[0;36m\] \`parse_git_branch\`\[\e[0m\]$ "
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'
# Tab completion for branch names
source ~/.git-completion.bash

# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbd='git branch --delete '
alias gbD='git branch -D '
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gcp='git cherry-pick'
alias gco='git checkout'
__git_complete gco _git_checkout
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gcl='git clone'
alias gd='git diff'
alias gda='git diff HEAD'
alias gi='git init'
alias glg='git log --graph --oneline --decorate --all'
alias gld='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gm='git merge'
alias gmf='git merge --no-ff'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gpl="git pull origin \`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'\`"
alias gplr='git pull --rebase'
alias gps="git push origin \`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'\`"
alias gpod="git push origin --delete"
alias gf='git fetch'
alias grb='git rebase'
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'
alias gr='git reset'
alias grh='git reset HEAD~1'

alias trash='git stash clear'

# ----------------------
# Git Functions
# ----------------------
# Git log find by commit message
function glf() { git log --all --grep="$1"; }

# ----------------------
# Other Aliases
# ----------------------
alias btop='BluetoothConnector 94-65-2d-22-d4-6c'
alias btsb='BluetoothConnector e8-07-bf-6c-70-43'

alias sasn='SwitchAudioSource -n'

alias yolo='rails db:reset'

alias ber='bundle exec rspec'
alias be='bundle exec'

# Disable/enable notification center
alias disableNotificationCenter="launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && killall NotificationCenter"
alias enableNotificationCenter="launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && open /System/Library/CoreServices/NotificationCenter.app/"

# RSpec shortcuts and autocompletion
_model () {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  k=0
  i="./spec/models/" # the directory from where to start
  for j in $( compgen -f "$i/$cur" ); do # loop trough the possible completions
  [ -d "$j" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
  COMPREPLY[k++]=${j#$i/} # remove the directory prefix from the array
done
return 0
}

_feature () {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  k=0
  i="./spec/features" # the directory from where to start
  for j in $( compgen -f "$i/$cur" ); do # loop trough the possible completions
  [ -d "$j" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
  COMPREPLY[k++]=${j#$i/} # remove the directory prefix from the array
done
return 0
}

_request () {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  k=0
  i="./spec/requests" # the directory from where to start
  for j in $( compgen -f "$i/$cur" ); do # loop trough the possible completions
  [ -d "$j" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
  COMPREPLY[k++]=${j#$i/} # remove the directory prefix from the array
done
return 0
}

function rspecmodels(){ rspec spec/models/"$@"; }
complete -o nospace -F _model rspecmodels
function rspecfeats(){ rspec spec/features/"$@"; }
complete -o nospace -F _feature rspecfeats
function rspecreqs(){ rspec spec/requests/"$@"; }
complete -o nospace -F _request rspecreqs

# Activate global Python ENV
alias activate='source ~/development/global_python_env/bin/activate'
