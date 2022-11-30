# CONTRIBUTING.md

## Contents
- [The Form of CONTRIBUTING.md](#the-form-of-contributingmd)

- [Prerequisites](#prerequisites)

- [Getting a Development Instance Operational](#getting-a-development-instance-operational)

- [Designating `thoth-tech/ChatHistoryDisplayer` as Upstream](#designating-thoth-techchathistorydisplayer-as-upstream)

- [Pushing to YOUR_GITHUB_USERNAME/ChatHistoryDisplayer](#pushing-to-your_github_usernamechathistorydisplayer)

## The Form of CONTRIBUTING.md
Besides the prerequisites, the following sections of this document will take the form:

```
## Title
### Purpose
The purpose of performing the actions.

### Actions
The actions to perform, which then result in the partial or total fulfilment of the purpose.
```

## Prerequisites
- A terminal capable of executing `sh` scripts (if you are on Windows, then WSL2, MSYS2, or similar).
- Docker (if you are on Windows, then Docker Desktop will suffice).

## Getting a Development Instance Operational
### Purpose
The purpose of the following is to get your own, remote copy (where we call a "remote copy" a "fork," from here onwards) of the ChatHistoryDisplayer into your GitHub repositories, a local copy of the ChatHistoryDisplayer onto your machine, and to be able to spin up a development environment with a simple command. In the development environment, changes to the front- and back-ends will reflect with a simple browser refresh.

### Actions
- Fork the repository, as the ChatHistoryDisplayer uses the [Forking Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/forking-workflow).

- Clone your fork of the ChatHistoryDisplayer. Replace `YOUR_GITHUB_USERNAME` with your GitHub username, in the following command:

  ```bash
  git clone https://github.com/YOUR_GITHUB_USERNAME/ChatHistoryDisplayer.git
  ```

- Enter the newly cloned directory via `cd ChatHistoryDisplayer`.

- Execute Docker Compose to get the development instance up.

  ```bash
  docker compose up
  ```

## Designating `thoth-tech/ChatHistoryDisplayer` as Upstream
### Purpose
The purpose of setting the `thoth-tech/ChatHistoryDisplayer` main branch as the upstream, is that anything merged into the main branch of the thoth-tech/ChatHistoryDisplayer remote repository can be pulled into your local main branch by:

```bash
git pull upstream
```

### Actions
- Add the `thoth-tech/ChatHistoryDisplayer` remote repository as the upstream.

  ```bash
  git remote add https://github.com/thoth-tech/ChatHistoryDisplayer.git
  ```

## Pushing to YOUR\_GITHUB\_USERNAME/ChatHistoryDisplayer
### Purpose
To get a change into the `thoth-tech/ChatHistoryDisplayer` main branch, you will need to push your local changes to your remote copy (the so-called "fork") of the application. After you have pushed these changes to your fork, then you will need to use GitHub to mediate a pull request from your remote copy to thoth-tech/ChatHistoryDisplayer main branch.

### Actions
- Push your changes to `origin`, a remote that is automatically added during the cloning process (`origin` refers to your fork of `thoth-tech/ChatHistoryDisplayer`).

  ```bash
  git push origin
  ```
