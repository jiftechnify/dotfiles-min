# configure plugins
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search"
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:"pure.zsh", from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# enable completions
autoload -Uz compinit; compinit -u

# enable custom prompt
autoload -U promptinit; promptinit
prompt pure > /dev/null

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias la='ls -a'
alias ll='ls -l'

# completions for go-task
# original: https://github.com/sawadashota/go-task-completions
# Listing commands from Taskfile.yml
function __list_tasks() {
    local -a scripts

    if ls Taskfile.y*ml > /dev/null 2>&1; then
        tasks=$(task -l | sed -En "s/^\* ([^[:space:]]+):[[:space:]]+(.+)$/\1 \2/p" | awk '{gsub(/:/,"\\:",$1)} 1' | awk "{ st = index(\$0,\" \"); print \$1 \":\" substr(\$0,st+1)}")
        scripts=("${(@f)$(echo $tasks)}")
        _describe 'script' scripts
    fi
}

_task() {
    _arguments \
        '(-d --dir)'{-d,--dir}'[sets directory of execution]: :_files' \
        '(--dry)'--dry'[compiles and prints tasks in the order that they would be run, without executing them]' \
        '(-f --force)'{-f,--force}'[forces execution even when the task is up-to-date]' \
        '(-i --init)'{-i,--init}'[creates a new Taskfile.yml in the current folder]' \
        '(-l --list)'{-l,--list}'[lists tasks with description of current Taskfile]' \
        '(-p --parallel)'{-p,--parallel}'[executes tasks provided on command line in parallel]' \
        '(-s --silent)'{-s,--silent}'[disables echoing]' \
        '(--status)'--status'[exits with non-zero exit code if any of the given tasks is not up-to-date]' \
        '(--summary)'--summary'[show summary about a task]' \
        '(-t --taskfile)'{-t,--taskfile}'[choose which Taskfile to run. Defaults to "Taskfile.yml"]' \
        '(-v --verbose)'{-v,--verbose}'[enables verbose mode]' \
        '(--version)'--version'[show Task version]' \
        '(-w --watch)'{-w,--watch}'[enables watch of the given task]' \
        '(- *)'{-h,--help}'[show help]' \
        '*: :__list_tasks'
}
