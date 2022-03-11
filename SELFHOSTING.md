# Self-hosting Guide

# Environment variables
Create an `.env` file in the root directory of the app. Use `.env.example` as a template. If you are running on a managed service like Heroku or Digital Ocean, input the environment variables in their system.

# Hosting
Fugu is a pure Ruby on Rails app requiring a Postgres database. Therefore, you can host it however you like. Below, we've added short guides for hosting with managed services like Heroku or using Docker.

## Heroku, DigitalOcean and other managed services
Managed services like Heroku, Digital Ocean and Render offer fast ways to deploy Ruby on Rails apps directly from GitHub. If you're using a managed service, have a look at their documentation on how to proceed. Normally, this is pretty straight forward.

In any case, don't forget to create the database after your first deploy, and migrate the database if you do any updates in the future:
`rails db:create`
`rails db:migrate`


## Docker
There are a couple of ways you can run Fugu with Docker.

### Docker image only
If you already have a Postgres server going and only need the Fugu app, you can use the Fugu Docker image.

The simplest way is to run the Fugu image that we upload to the Docker registry:
`docker run --env-file .env fugu/fugu:latest`

If you prefer to build the image locally, you can do it like this before running it:
`docker build -f Dockerfile.prod -t fugu/fugu`

If you're setting up Fugu for the first time, make sure to create the database before running the server:
`docker run --env-file .env fugu/fugu:latest rails db:create`

### Docker image and Postgres database

If you don't have an existing Postgres databse running on your server, we provide a `docker-compose` configuration that might come in handy.
There are 3 different `docker-compose` configurations:
- `docker-compose.prod-remote.yml` uses the remote `fugu/fugu:lates` image from the Docker registry
- `docker-compose.prod.yml` builds the image first based on `Dockerfile.prod`
- `docker-compose.dev.yml` is meant to be used when developing Fugu

In most cases, you would just want to go with the remote image:

`docker-compose -f docker-compose.prod-remote.yml up`

If you're setting up Fugu for the first time, make sure to create the database before running the server:
`docker-compose -f docker-compose.prod-remote.yml run web rails db:create`

`docker-compose` uses the environment variables defined in your local `.env` file.


## Tips

### ALLOW_NEW_ACCOUNTS
After you've creatd your own account on your self-hosted instance, we recommend to set the environment variable `ALLOW_NEW_ACCOUNTS` to `false`. Otherwise, random people who know your URL can create Fugu accounts on your instance.

## Questions and help
If you have any questions, check out our [GitHub Discussions](/discussions).