# Overview
This CU Libraries repository for all things reporting, including but not limited to creating reports from FOLIO data.

It is our intention that this repository serve as the central hub for all things relevant to reporting (docs, source code and issues). If a report exists, it will have a [wiki page](/wiki) and an entry in the current reports section of the wiki home, even if it only contains notes or TODOs. In fact, putting notes and TODOs in this file is totally fine.

# Contributing to this project
There are several ways to contribute. All are welcome.

* You can create a new report
* You can run an [existing report](/wiki)
* You can [create an issue](/issues) or comment on one

See the section below for the steps for running a report or creating a new report.

Creating an issue is the easiest way to contribute. Have an idea for a report? Follow the steps below for how to get things going.

# What is a report?
A report consists of data that helps you in your work. It may come from FOLIO or it may come from other systems. After a report is "run" it may consist of columns and rows of data. But a report, as we define it, also refers to the _documentation for how to generate the report_. These docs will allow others, and maybe even your future self, to run and perhaps contribute to the report's development.

# Running or creating a report
All new reports should have an issue and a wiki page. All existing reports will have at least a wiki page. Reports that have source code may have both a wiki page and a readme.

To run a report:

Check the [wiki](/wiki) to see to see if your report exists. If it does, follow the documentation there on how to run it.

If the report doesn't yet exist, you'll need to create one. Here's how to do that:
1. [Create an issue](/issues) for your report. Without an issue it is likely your report won't be seen by others or get worked on. Consider tagging other interested parties in your issue. Issues are great places to collaborate.
1. Create a [wiki](/wiki) page for your report. Congratulations, your report now exists! Link to the issue you created on the wiki page for the time being. Link to the wiki page from the issue. Feel free to use the wiki page to document your progress or keep notes in case someone else needs to take things up where you left off.
1. Create an entry for your report in the current reports section of the [wiki home page](/wiki). Set the status to in progress. Give your report a priority. See the [report priority guide](/wiki/report-priority-guide).
1. Create a one or two sentence description for your report. Put this both on the wiki page for your report and in the issue. Consulting the [report documentation guide](/wiki/report-documentation-guide) may be helpful at this point.
1. Figure out the [data sources](/wiki/report-data-sources) for your report. There are many ways to get library data, from running a query inside of FOLIO, to creating a SQL query. Document your progress in the wiki page or your issue, whatever seems most appropriate.
1. Ask for help! If at any point in the process, you're feeling stuck, reach out to the reporting pod on Teams. We'll get you going in the right direction!
1. Once you've figured out your [data sources](/wiki/report-data-sources) and have run your report, finish up the wiki page about your report, consulting the [report documentation guide](/wiki/report-documentation-guide).
1. Finish up the entry for your report in the current reports section of the [wiki home page](/wiki). Set the status to done.
1. If your report has source code associated with it, open a pull request so that others can take a look at it and it can get merged to the main branch. See below for more on pull requests.
1. You can now close the issue [issue](/issues) associated with your report.

## Issue or wiki?
Issues are good for collaboration. The wiki page is more permanent. Issues ultimately should be closed when the work is complete. Wiki pages hang around forever.

# Current reports
The [wiki](/wiki) is the central location for all documentation of current reports. Check this first to see if your report or something like it already exists or is underway.

# Working with github and git
Github and git are central to our reporting work. If you need to create or collaborate on a report that has source code associated with it, it is highly recommended that you install and use git on your local machine.

## Installing git
Install git following the instructions [here](https://github.com/git-guides/install-git).

Clone this repo, make a branch for your work, add some stuff, and push. Here's how.

```sh
# Clone this repo.
git clone https://github.com/culibraries/library-reporting.git
cd library-reporting
# Create a branch.
git checkout -b issue-1-add-readme-file-etc
# Make some files. You can do this any way you like. Here is one way:
mkdir my-report-name
touch my-report-name/README.md
# Add your changes to the git index. You do this before any commit.
# The period says add all.
git add .
# Now do your commit.
git commit -m "Adding files"
# Push them.
git push --set-upstream origin issue-1-add-sections-to-readme-github
```

That last bit says "push this branch to the remote repository" (the upstream origin part).

Afterwords you can continue to push using the simpler `git push`. It will remember where you're pushing to.

The [git guides](https://github.com/git-guides) are super helpful for more documentation if that's your thing.

## Authenticating to github from the command line
You don't need to be logged into github to `clone` and `pull`. But you do need to be logged in to `push`. Creating a personal access token is the way to log in. Once you have done so, you use it like a password. Also make sure to protect it like one too!

To create a personal access token:
1. Follow the instructions [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token).
2. Copy the token to your clipboard.
3. When prompted to login (when you push for example) enter your github username for username, and then the personal access token for your password. Instructions [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token#using-a-token-on-the-command-line).

To find your github username, login to github and navigate to your profile. This is also where you create the personal access token.

## Branches and issues
Ideally a branch will be tied to an issue through its name. If you're creating a branch without an issue, [create an issue](https://github.com/culibraries/library-reporting/issues) for it first.

Give your issue a title. Something like "Create items lost in transit report" is an example. This can be used in your branch name like this: `issue-10-create-items-lost-in-transit-report`. That way anyone glancing at the branch can easily locate the issue.

## Pull requests
Once you've got some work that you'd like to make permanent, you're ready to make a _pull request_. A pull request says to collaborators "Hey I think this is ready. Can you take a look?"

To make a pull request:
1. Look for your latest commit on your branch.
2. Click on the **Compare & Pull Request** button.
3. Collaborate on the PR.
4. Once one of your collaborators approves it you can hit **Squash and Merge**.
5. Delete your branch using the **Delete Branch** button.

Squashing is almost always good at this stage, because it combines all of your commits into one, making the history much easier to follow.

On your local machine, remember to checkout main by doing `checkout main` and then pull your (and other's changes) by doing `git pull`.

If you haven't done a pull request before (don't worry it's easy) you can always ask someone who has to show you the ropes.
