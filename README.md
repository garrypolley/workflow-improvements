# workflow-improvements

Contains helpers that make my day-to-day workflow easier

## GH cli

Here is what I've done to make gh cli a lot easier to manage and deal with. It makes working in git a lot
easier for me.  Generally I do a lot with github every day -- so having `gh` installed is great.

```bash
brew install gh
gh auth login
```

### GH cli aliases

See [gh_cli.md](gh_cli.md) for the full list of aliases and their usages.

```sh
clean-up:               !gh co-default && git pull
clup:                   !gh clean-up
co:                     pr checkout
co-default:             !branch="$( gh default-branch)"; [ -n "$branch" ] &&  git checkout $branch
co-pr:                  !gh clean-up && gh pr-branch-name $1 | xargs git checkout
create-pod-pr:          !team="$( gh team-members $TEAM_ENV)"; [ -n "$team" ] &&  gh pr create -r "$team" -r "$ORG/$TEAM_ENV"
default-branch:         !gh api /repos/{owner}/{repo} --jq '.default_branch'
list-team-prs:          !gh team-members-new-line $TEAM_ENV | xargs -L1 -I {} gh search prs --state=open --review-requested=@me --json url --author ...
needs-review:           !gh search prs --state=open --review-requested=@me --sort created --json url --jq ".[].url"
pr-branch-name:         !gh pr list --json url,headRefName --jq ".[] | select(.url == \"$1\") | .headRefName"
team-members:           !gh api orgs/u21/teams/$1/members --jq '[.[].login] | join(",")'
team-members-new-line:  !gh api orgs/u21/teams/$1/members --jq '[.[].login] | join("\n")'
```
