#
# ~/.bashrc
#

### infinite history
HISTSIZE=
HISTFILESIZE=

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### comand prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[\033[38;5;195m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;11m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]\[\033[38;5;204m\]\$(parse_git_branch)\[$(tput sgr0)\]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;224m\] > \[$(tput sgr0)\]"

alias sudo='sudo '

### user environment
export M2_HOME="/opt/maven"
export JAVA_HOME="/usr/lib/jvm/default"
export PATH=$PATH:$M2_HOME/bin
export EDITOR=kate
export KUBECONFIG=~/.kube/config:~/.kube/config-local
export GTK_THEME=Adwaita:dark meld gitkraken

### clipboard
alias paste="xclip -selection clipboard c -o"
alias copy="xclip -sel c <"

### system
output_DP=$(xrandr | grep " connected" | grep DP | awk '{print $1}')
output_LVDS=$(xrandr | grep " connected" | grep LVDS | awk '{print $1}')

alias auto='xrandr --output $output_LVDS --auto --output $output_DP --auto --right-of $output_LVDS'
alias off='xrandr --output $output_LVDS --off'
alias on='xrandr --output $output_LVDS --auto'

alias bashrc="vim ~/.bashrc; source ~/.bashrc;"
alias print="cat ~/.bashrc"
alias s='source ~/.bashrc'

alias lock='xscreensaver-command -lock'
alias xresources='xrdb ~/.Xresources'
alias reload="i3-msg reload; i3-msg restart"

alias ls='ls --color=auto'
alias kill-port="fuser -k \$1/tcp"
alias config='/usr/bin/git --git-dir=/home/bartek/.cfg/ --work-tree=/home/bartek'
alias update='curl -s "https://www.archlinux.org/mirrorlist/?country=DE&country=PL&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -'

### docker
alias d_stop="docker stop \$(docker ps -aq)"
alias d_start="docker-compose up -d"
alias d_remove="docker rm \$(docker ps -aq)"
alias d_rebuild="docker-compose pull; docker-compose up -d"
alias d_ps="docker ps | less -S"

### mongo 
alias mongo_init="docker exec ris-mongodb mongo --eval 'rs.initiate()'"

### maven
alias m_install="mvn clean install -DskipTests "
alias m_build="mvn install -T 4 -Dmaven.test.skip=true "
alias m_clean="mvn clean:clean -T 4 "
alias ba="m_clean -pl app -P dev && m_install -pl app -P dev "
alias b="m_clean -P dev && m_install -P dev"
alias modules="mvn --also-make dependency:tree | grep maven-dependency-plugin | awk '{ print \$(NF-1) }'"
alias int="mvn clean install -T 8 -Pintegration-tests -P dev -pl app"
alias run="mvn spring-boot:run -P dev -pl app"

### kubectl
alias k=kubectl
alias k_pods="k get pods"
alias k_contexts="k config get-contexts"
alias k_use="k config use-context "
complete -F __start_kubectl k

### git
switch="!f() { git checkout $1 2>/dev/null || git checkout -b $1; }; f"
alias gp="git push "
function gca() {
    git add .;
    git commit -m "$1";
    git push;
    git push -u origin HEAD;
}
alias gc="git checkout "
alias gs="git status"
alias gd="git difftool"
alias gds="git difftool --staged"
alias ga="git add ."
alias grh="git reset --hard "
alias grs="git reset --soft "
alias gsta="git stash apply "
alias gst="git stash " 
alias gl="git log -n 5"
alias gpu="git pull "
alias g_master="git reset --hard; git checkout master; git reset --hard origin/master;  git pull;"
alias g_prune="git remote prune origin"
alias g_clean="git branch | xargs git branch -D && git pull "

function g_only_master() {
    for remote in `git branch -r `; do git branch --track $remote; done
    git branch --merged master | grep -v master | cut -d/ -f2- | xargs -n 1 git push --delete origin
}

### funkcja Marcina
function fed {
    yes '' | sed 5q
    for d in `ls`; do ( 
            cd $d; 
            echo -e "\033[38;5;11m$d\033[0m";
            ( eval "$@" ) 
            echo -e "\033[38;5;11m$d\033[0m \033[38;5;204m$(parse_git_branch)\033[0m";
            echo;
    ); done;
    yes '' | sed 5q
}

function f {
    yes '' | sed 5q
    for d in `ls`; do ( 
            cd $d; 
            echo -e "\033[38;5;11m$d\033[0m";
            if [[ `git status --porcelain` ]]; then
                ( eval "$@" ) 
                echo -e "\033[38;5;11m$d\033[0m \033[38;5;204m$(parse_git_branch)\033[0m";
                echo;
            fi
        ); 
    done;
    yes '' | sed 5q
}

function fed_2 {
    declare -a pids
    i=0
    yes '' | sed 5q
    for d in `ls`; do ( 
            cd $d; 
            echo -e "\033[38;5;11m$d\033[0m";
            command=($@)
            "${command[@]}" 2> /dev/null &
            pids[${i}]=$!
            echo -e "\033[38;5;11m$d\033[0m \033[38;5;204m$(parse_git_branch)\033[0m";     
            i=$((i+1))
            ((i=i+1))
            echo;
    ); done;
    yes '' | sed 5q

    for pid in ${pids[*]}; do
        wait $pid
    done
}

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

if [ -n "$DISPLAY" ]; then
    export BROWSER=chromium
fi

if [ -f ~/.project ]; then
  . ~/.project
fi

