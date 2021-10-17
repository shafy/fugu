## Contribution Guide

## Contribution Rules

This is an open-source project and we welcome contributions that improve the code, UX/UI and add new features. However, this doesn't mean that we will accept all contributions. The best way to contribute is to check the open issues or ask me (canolcer@hey.com) if there's something you can contribute to.
If you want to contribute, fork this repo and create a pull request with your changes that we can review.


## Development

## Gitpod

We recommend developing with the excellent cloud-based development environment provided by [Gitpod](gitpod.io/). To start your ready-to-code development enviroment just add `gitpod.io/#` in front of the GitHub URL for any branch, or [click here](https://gitpod.io/#https://github.com/shafy/fugu) to get started with the main branch.

## Docker

We haven't set up Docker for this project yet, but feel free to send a PR with a working setup if you do get to it.

### Old school

Dependencies:
- ruby ~3.0.0
- rails ~6.1.3
- postgres ^13.2

Install the dependencies on your machine & set up an user in Postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env

# Create and migrate the database
rails db:create db:migrate

# Finally, run the app locally
rails s
```