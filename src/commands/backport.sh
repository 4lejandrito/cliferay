WHITE='\033[00;97m'
BOLD_WHITE='\033[01;97m'
NC='\033[0m' # No Color

TEXT=${args["text"]}
SOURCE_BRANCH=${args["--branch"]:-ce/master}

COMMITS=$(git log $SOURCE_BRANCH --format="%H" --grep=^$TEXT | tac)

echo -e "${BOLD_WHITE}Commits in chronological order:${NC}"
echo ""

git --no-pager show --no-patch --oneline $COMMITS
echo ""

echo -n -e "${BOLD_WHITE}Do you want to cherry pick all these commits? (y/n)${WHITE} "
read answer
echo -e "${NC}"

if [[ "$answer" == "y" ]]; then
    git checkout -b $(git rev-parse --abbrev-ref HEAD)-$TEXT
    git cherry-pick $COMMITS
else
    echo "No problem. Try some other time."
fi
