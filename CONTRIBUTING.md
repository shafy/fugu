## Contribution Guide

## Contribution Rules

This is an open-source project and we welcome contributions that improve the code, UX/UI and add new features. However, this doesn't mean that we will accept all contributions. The best way to contribute is to check the open issues or ask me (canolcer@hey.com) if there's something you can contribute to.
If you want to contribute, fork this repo and create a pull request with your changes that we can review.

If you have any questions, head over to our [GitHub Discussions](https://github.com/shafy/fugu/discussions) page.


## Development

### Setup

There are a few ways you can get started with Fugu on your local machine.

### Gitpod

We recommend developing with the excellent cloud-based development environment provided by [Gitpod](gitpod.io/). To start your ready-to-code development enviroment just add `gitpod.io/#` in front of the GitHub URL for any branch, or [click here](https://gitpod.io/#https://github.com/shafy/fugu) to get started with the main branch. Don't forget to add the environment variables from `.env.example` to your Gitpod account.

### Docker

You can build the Docker image using the `Dockerfile.dev` configuration. If you don't have an existing PostgreSQL service on your machine, you can use our `docker-compose` setup to also start a PostgreSQL database. Just run `docker-compose -f docker-compose.dev.yml up`.

Don't forget to create an `.env` file using `.env.example` as a template.

Before running the app, make sure to create the server with `docker run --env-file .env your_image rails db:create` or `docker-compose -f docker-compose.dev.yml run web rails db:create`, respectively.

### Old school

Dependencies:
- ruby ~3.0.0
- rails ~7.0.0
- postgres ^13.2

Install the dependencies on your machine & set up an user in Postgres. Then:
```
# Set the .env files and fill in all env vars
cp .env.example .env

# Create and migrate the database
rails db:create db:migrate
```

## Starting the server
To start the server, run `./bin/dev` or run `rails s` and `rails tailwindcss:watch` as separate processes (the first command does basically the same with `foreman`). This is necessary because we need the [Tailwind](https://github.com/rails/tailwindcss-rails) watch process during development.


## Fugu Cloud

There are a few places in the codebase where you will encounter logic that is only needed for Fugu Cloud, the hosted solution by us. These parts of the code are not needed if you are self-hosting, and probably also not relevant for you as a contributor. For the most part this concerns code that relates to payment and subscriptions.

Currently, we use the environment variable `FUGU_CLOUD` to determine if the instance is being self-hosted or not. Later on, we might improve this structure by factoring out the main code base to a Rails Engine.