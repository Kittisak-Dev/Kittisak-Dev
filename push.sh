BLACK="\e[30m";RED="\e[31m";GREEN="\e[32m";YELLOW="\e[33m";BLUE="\e[34m";MAGENTA="\e[35m";CYAN="\e[36m";
GRAY="\e[90m";LRED="\e[91m";LGREEN="\e[92m";LYELLOW="\e[93m";LBLUE="\e[94m";LMAGENTA="\e[95m";LCYAN="\e[96m";
LBBLACK="\e[1;30m";LBRED="\e[1;31m";LBGREEN="\e[1;32m";LBYELLOW="\e[1;33m";LBBLUE="\e[1;34m";LBMAGENTA="\e[1;35m";LBCYAN="\e[1;36m";
NOCOLOR="\e[0m";CLEAN="\033[2K"

TIME=0;
TIMEEND=5;
SP='/-\|';
SPT=0;

function Loading {
    for I in $(seq 0 10); do
        test $SPT -eq 4 && SPT=1 || SPT=$(($SPT + 1));
        echo -en "${SP:SPT%${#SP}:1} \r";
        sleep 0.1;
    done
}

function Check {
    source .env;
    if test -R $GIT_NAME; then ERROR=1 && Error; fi;
    if test -R $GIT_MAIL; then ERROR=2 && Error; fi;
}

function Error {
    test $ERROR -eq 1 && eval 'echo -e ${NOCOLOR}[${RED}ERROR${NOCOLOR}] ${LRED}Not found GIT_NAME in file .env && exit' || sleep 0
    test $ERROR -eq 2 && eval 'echo -e ${NOCOLOR}[${RED}ERROR${NOCOLOR}] ${LRED}Not found GIT_MAIL in file .env && exit' || sleep 0
}

function Config {
    read -p $'  \e[0m[\e[36mPROCESS\e[0m] \e[33mCommit message \e[0m: ' GIT_MESSAGE;
    git add .;
    git config --local user.name "${GIT_NAME}";
    git config --local user.email "${GIT_MAIL}";
    git commit --author="${GIT_NAME} <${GIT_MAIL}>" -m "${GIT_MESSAGE}";
}

function GitInitial {
    read -p $'  \e[0m[\e[36mPROCESS\e[0m] \e[33mRepository link \e[0m: ' GIT_LINK;
    read -p $'  \e[0m[\e[36mPROCESS\e[0m] \e[33mBranch name \e[0m: ' GIT_BRANCH;
    git init;
    Config;
    git branch -M ${GIT_BRANCH};
    git remote add origin ${GIT_LINK};
    git push --set-upstream -f origin ${GIT_BRANCH}
    wait
    echo -en "  ${CLEAN}${NOCOLOR}[${GREEN}FINISHED${NOCOLOR}] ${CYAN}Successfully committed and pushed";
    exit;
}

function Upload {
    echo -en "  ${CLEAN}${NOCOLOR}[${GREEN}INFO${NOCOLOR}] ${YELLOW}Committing\r";
    sleep 0.5 && Loading;
    Config;
    git push origin "main"
    wait
    echo -en "  ${CLEAN}${NOCOLOR}[${GREEN}FINISHED${NOCOLOR}] ${CYAN}Successfully committed and pushed";
    exit;
}

if (($TIME < $TIMEEND)); then
    echo -en "  ${NOCOLOR}[${GREEN}START${NOCOLOR}] ${YELLOW}Upload to github\r";
    sleep 0.5 && Loading;
    echo -en "  ${NOCOLOR}[${GREEN}EXECUTE${NOCOLOR}] ${YELLOW}Executing file\r";
    sleep 0.5s && Loading;
    Check;
    test -d ".git" && Upload || GitInitial;
fi