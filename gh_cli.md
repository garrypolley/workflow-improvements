# GH cli

Here is what I've done to make gh cli a lot easier to manage and deal with. It makes working in git a lot
easier for me.  Generally I do a lot with github every day -- so having `gh` installed is great.

```bash
brew install gh
gh auth login
```

## GH cli aliases

Here are my current aliases:

```sh
clean-up:               !gh co-default && git pull
clup:                   !gh clean-up
co:                     pr checkout
co-default:             !branch="$( gh default-branch)"; [ -n "$branch" ] &&  git checkout $branch
co-pr:                  !gh clean-up && gh pr-branch-name $1 | xargs git checkout
create-pod-pr:          !team="$( gh team-members $TEAM_ENV)"; [ -n "$team" ] &&  gh pr create -r "$team" -r "$ORG/$TEAM_ENV"
default-branch:         !gh api /repos/{owner}/{repo} --jq '.default_branch'
list-team-prs:          !gh team-members-new-line $TEAM_ENV | xargs -L1 -I {} gh search prs --state=open --review-requested=@me --json url --author {} --jq ".[].url"
needs-review:           !gh search prs --state=open --review-requested=@me --sort created --json url --jq ".[].url"
pr-branch-name:         !gh pr list --json url,headRefName --jq ".[] | select(.url == \"$1\") | .headRefName"
team-members:           !gh api orgs/u21/teams/$1/members --jq '[.[].login] | join(",")'
team-members-new-line:  !gh api orgs/u21/teams/$1/members --jq '[.[].login] | join("\n")'
```

I currently hard code the `$TEAM_ENV` variable to my team slug. I also hard code the `$ORG` to my current github org.

Commands I use all the time

### gh clean-up

This command makes it easier to clean up my local branches. It will checkout the default branch and update. From there
I usually start my next bit of work with a `git checkout -b <branch-name>`.

### gh co-pr

This command makes it way easier to get all setup with reviewing a PR on my local machine. I run it like this:

```sh
gh co-pr https://github.com/ORG/REPO/pull/PR_NUM
```

This checks out the head of the PR's branch and puts me on it. It runs a `gh clean-up` first to ensure I'm not in a
bad state before I start the pull request review.

### gh list-team-prs

I use this one to make sure I'm up-to-date with what my team needs my help reviewing. It'll output the URLs of all
PRs that need my review for my team.

```sh
➜  workflow-improvements git:(main) gh list-team-prs
https://github.com/ORG/REPO/pull/7735
https://github.com/ORG/REPO/pull/4082
https://github.com/ORG/REPO/pull/2986
https://github.com/ORG/REPO/pull/3018
https://github.com/ORG/REPO/pull/4135
https://github.com/ORG/REPO/pull/7728
https://github.com/ORG/REPO/pull/4129
https://github.com/ORG/REPO/pull/7712
https://github.com/ORG/REPO/pull/4119
```

### create-pod-pr

This command makes it much easier for me to create PRs for my team to review. It assigns each person on the team individually as well
as the team itself. This ensures everyone sees the PR in their assignments and makes it so anyone on the team can approve as needed.

```sh
gh create-pod-pr
```

This will then walk you through the steps of creating the PR just like the usual `gh create pr` does.
