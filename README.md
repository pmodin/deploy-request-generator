# Deploy request email generator

This is refinement of a simple Bash-script that my co-worker had written for the purpose of generating deploy request emails.
The tool generates a `mailto`-link which is then opened with either `xdg-open` or `open`, depending on whether you're on Linux or OSX.

A sample generated email may look like this:

    Subject: Deploy request [no special] for mm-some_feature_branch

```
# Branch
mm-some_feature_branch

# Commits
e0b217d Mandatory whitespace commit
8300ada Remove old stuff
db52672 Implement another thing
7a14d55 Fix some thing

# Shortstat
3 files changed, 70 insertions(+), 43 deletions(-)

# Referenced issues
https://issue.tracker.com/issues/57
https://issue.tracker.com/issues/123
https://issue.tracker.com/issues/958
```

## Usage

Clone the repository and then [configure the script](#configuration).

Once the configuration is in place:

1. Change your directory to the project you wish to send a deploy request from.
2. Change your git branch to the feature branch you wish to send a deploy request mail for.
3. Run `deployrequest.rb`, wherever you've placed it.

The script should open your preferred email client with the deploy request email.

### Referenced issues

Do note that the "Referenced issues" feature works on the assumption that you specify what issue a commit references by having dedicated ref-lines (for instance at the end of commits) as follows:

```
commit 21b6fa0c21fc4d014532265b36ed2e57374f4d8e
Author: Mikael Muszynski <linduxed@gmail.com>
Date:   Wed Oct 20 13:49:45 2014 +0200

    First line of commit message

    Some extra information.

    refs #7418
```

### Special deploy requests

A deploy request can be marked as a `[SPECIAL]` one or a `[no special]` one.
This has to do with our deployment practices.
If we would need to do something special with our server setup for a build to work, then this needs to be indicated and instructions need to be included.

When running the application a prompt gets shown which asks whether the deploy request is special or not.
If it is, the subject of the mail will be changed and the body will include an extra space where one can include instructions for the deploy officer.

## Configuration

The generator needs to be configured with a `settings.yml` file.
Copy and tweak the existing `settings.yml.sample` to your liking.

Here's a brief explanation of what the different settings do:

* `email_to` - What address will the deploy request be sent to.
* `issue_tracker_url` - The URL of the issue tracker.
* `default_allowed` - Whether the user should be allowed to just press Enter when choosing whether a deploy request is special or not.
* `default_special` - If above option is set to `true`, this determines what the default choice should be.
