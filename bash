alias editor='subl'
alias gs='git status -sb'
alias bash="editor -n ~/.defaults ~/.defaults/bash"
alias hosts="editor -n /etc/hosts /etc/apache2/extra/httpd-vhosts.conf && editor --command next_view"
alias ls="ls -la"

function init() {
  project=${1}
  if [ -z "$project" ]
  then
    echo -ne "Project Name: "
    read project
  fi
  cd ~/Projects
  curl -L https://github.com/garand/base/archive/master.zip > "$project".zip
  unzip "$project".zip -d "$project"
  rm "$project".zip
  cd "$project"
  mv base-master/* ./
  mv base-master/.gitignore ./
  rm -R base-master
  sed -i "" "s/\"name\": \"base\"/\"name\": \"$project\"/g" package.json
  mkdir assets/img
  git init
  git add .
  git commit -m "Initial commit"
  npm install
  editor . index.html assets/scss/main.scss assets/js/main.js && editor --command next_view
  gulp
}

function p() {
  project=${1:-}
  cd ~/Projects/"$project"
}

function e() {
  project=${1:-}
  cd ~/Projects/"$project"
  editor .
}

function server() {
  port=${1:-8000}
  open http://localhost:"$port" && php -S 0.0.0.0:"$port";
}

function deploy() {
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  echo ""
  echo "Deploying to GitHub"
  echo "-------------------"
  git push origin "$branch"
  echo ""
  echo "Deploying to Heroku"
  echo "-------------------"
  git push heroku "$branch":master
  echo ""
}

function apache() {
  apache_command=${1:-restart}
  sudo apachectl "$apache_command";
}

function mysql() {
  mysql_command=${1:-start}
  mysql.server "$mysql_command";
}

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

find_git_dirty() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
		local status=$(git status --porcelain 2> /dev/null)
	  if [[ "$status" != "" ]]; then
	  	prompt_icon='🚨 '
	  else
	  	prompt_icon='🚀 '
	  fi
	else
	  prompt_icon='⚡ '
	fi
}

[[ -f /etc/profile ]] && . /etc/profile

txtblk='\e[1;30m' # Black
txtred='\e[1;31m' # Red
txtgrn='\e[1;32m' # Green
txtylw='\e[1;33m' # Yellow
txtblu='\e[1;34m' # Blue
txtpur='\e[1;35m' # Purple
txtcyn='\e[1;36m' # Cyan
txtwht='\e[1;37m' # White

PROMPT_COMMAND="find_git_dirty;$PROMPT_COMMAND"

PS1="\W\[$txtblu\]\$(parse_git_branch) \[$txtwht\]\$prompt_icon "