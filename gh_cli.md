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
list-branches:          !printf "  %-35.35s | %-50.50s  \n\n" "Repo" "Current Branch" && gh repo list $GIT_ORG --json name --jq ".[].name" | xargs -L1 -I {} sh -c "cd $ORG_GIT_ROOT/{} 2> /dev/null && echo {} && git branch --show-current" | xargs -n 2 | xargs -L1 -I {} sh -c "printf \"| %-35.35s | %-50.50s |\n\" {}
default-branch:         !gh api /repos/{owner}/{repo} --jq '.default_branch'
list-team-prs:          !gh team-members-new-line $TEAM_ENV | xargs -L1 -I {} gh search prs --state=open --review-requested=@me --json url --author {} --jq ".[].url"
list-team-prs--open:    !gh team-members-new-line $TEAM_ENV | xargs -L1 -I {} gh search prs --state=open --json url --author {} --jq ".[].url"
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

### gh list-team-prs--open

This will list out all PRs the team has open -- even if I've already reviewed them. It will have the same or more than the `gh list-team-prs` command. 

```sh
➜  ~ gh list-team-ORG--open
https://github.com/ORG/REPO/pull/1475
https://github.com/ORG/REPO/pull/3125
https://github.com/ORG/REPO/pull/4330
https://github.com/ORG/REPO/pull/4318
https://github.com/ORG/REPO/pull/3997
https://github.com/ORG/REPO/pull/3276
https://github.com/ORG/REPO/pull/4337
https://github.com/ORG/REPO/pull/59
https://github.com/ORG/REPO/pull/65
https://github.com/ORG/REPO/pull/3533
https://github.com/ORG/REPO/pull/3104
https://github.com/ORG/REPO/pull/4314
```

### gh list-branches

This command may be used to show all your currently checked out branches for the organization you've set. 

|ENV| Meaning|
|--|--|
|ORG_GIT_ROOT| the root you've done a checkout of your org, assumes you've checked out all org repos in one folder|
|GIT_ORG| is the name for your org -- assumes it matches across all repos and that you're in one org |


```sh
➜  ~ gh list-branches
  Repo                                | Current Branch

| repo1                               | get-image-working-again                            |
| repo2                               | dd-hotfix/20221202                                 |
| repo3                               | master                                             |
| repo4                               | bug/sc-36576/ttt-namey-for-thing                   |
| repo5                               | dd-hotfix/20221202                                 |
| repo6                               | dd-hotfix/20221202                                 |
| repo7                               | bug/sc-36576/tty-namey-for-thing                   |
| repo8                               | master                                             |
| repo9                               | master                                             |
| repo10                              | main                                               |
| repo11                              | master                                             |
| repo12                              | main                                               |
```

Can be helpful to know the state of your locally running system. Especialy when repositories have dependencies on one another. 
