WHITE='\033[00;97m'
BOLD_WHITE='\033[01;97m'
NC='\033[0m' # No Color

TEXT=${args["text"]}
SOURCE_BRANCH=${args["--branch"]:-master}

COMMITS=$(git log $SOURCE_BRANCH --format="%H" --grep=^$TEXT | tac)

if [[ -z "$COMMITS" ]]; then
  echo "No commits found matching '$TEXT'"
  exit 0
fi

echo -e "${BOLD_WHITE}Commits in chronological order:${NC}"
echo ""

git --no-pager show --no-patch --oneline $COMMITS
echo ""

echo -n -e "${BOLD_WHITE}Do you want to revert all these commits? (y/n)${WHITE} "
read answer
echo -e "${NC}"

if [[ "$answer" == "y" ]]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    NEW_BRANCH="${CURRENT_BRANCH}-revert-$TEXT"

    git checkout -B "$NEW_BRANCH"
    git revert --no-edit $COMMITS || {
        echo "Conflict detected. Resolve manually and run 'git revert --continue'"
        exit 1
    }
else
    echo "No problem. Try some other time."
fi
