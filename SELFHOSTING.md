# Self-Hosting Guide

Fugu is open-source and can be self-hosted without any feature restrictions. Follow this guide to get started with self-hosting. If you have any questions, don't hesitate asking on our [GitHub Discussions](https://github.com/shafy/fugu/discussions) page.

## Environment variables

Create an `.env` file in the root directory of the app. Use `.env.example` as a template. If you are running on a managed service like Heroku or DigitalOcean, enter the environment variables in their system.

## Hosting
Fugu is a pure Ruby on Rails app requiring a PostgreSQL database. Therefore, you can host it however you like. Below, we've added short guides detailing a few popular self-hosting options.

### Heroku, DigitalOcean and other managed services
Managed services like Heroku, Digital Ocean and Render offer fast a quick and simple way to deploy Ruby on Rails apps directly from GitHub. If you're using a managed service, have a look at their documentation on how to proceed. Normally, this is pretty straight forward.

Don't forget to create the database after your first deploy, and migrate the database if you do any updates in the future:
```shell
# run after the initial deploy
rails db:create

# run this after every deploy
rails db:migrate
```

### Docker
There are a couple of ways you can run Fugu with Docker.

#### Docker image only
If you already have a PostgreSQL server going and only need the Fugu app, you can use the Fugu Docker image.

The simplest way is to run the [Fugu image](https://hub.docker.com/r/shafyy/fugu) that we upload to the Docker registry:

`docker run --env-file .env shafyy/fugu:latest`

If you prefer to build the image locally, you can do it like this before running it:

`docker build -f Dockerfile.prod -t shafyy/fugu .`

The default entrypoint file `docker-entrypoint.sh` in `Dockerfile.prod` automatically creates the database and runs schema migrations. You are free to override the entrypoint when you're running your container.

To create the database and run migrations manually, you can run the container like so:
```shell
# creates database
docker run --env-file .env shafyy/fugu:latest rails db:create

# runs any pending schema migrations
docker run --env-file .env shafyy/fugu:latest rails db:migrate
```

Note that you can run the database creation and migration commands however you like (e.g., with `docker exec` if you have a running container, or if you're in the shell of a running container directly with `rails db:migrate`).

#### Docker image and database (docker-compose)

We provide a docker-compose configuration that sets up everything you need to run Fugu, including PostgreSQL.
There are 3 different `docker-compose` configurations:

- `docker-compose.prod-remote.yml` uses the remote `shafyy/fugu:latest` image from the Docker registry
- `docker-compose.prod.yml` builds the image first based on `Dockerfile.prod`
- `docker-compose.dev.yml` is meant to be used when developing Fugu

In most cases, you would just want to go with the remote image:

`docker-compose -f docker-compose.prod-remote.yml up`

The `docker-compose` configuration automatically creates and runs migrations for you (see `docker-entrypoint.sh` for more info).

Note: `docker-compose` uses the environment variables defined in your local `.env` file.

If you want to use a different `docker-compose` configuration, simply pass its file name to the `-f` option in the commands above.

### Elestio

[Elestio](https://elest.io) make deploying open-source software a breeze by offering a fully managed environment. You can select from different providers (e.g., Hetzner, Digital Ocean) or on-premise and then deploy Fugu (or other open-source software they support) with the click of a button.

## Tips

### FORCE_SSL_PROD
If your hosting setup uses localhost internally (e.g., if you have a reverse proxy in front of your Docker setup), you might want to set the environment variable `FORCE_SSL_PROD` to `false`. Otherwise, Rails will force the traffic to `https://localhost`, which then leads to an exception in the Puma server.

### Creating and initial user
After you've deployed Fugu for the first time, you can simply navigate to the root URL and create a user account. If for some reason you want to create an initial user account automatically, define the environment variables `INIT_USER_EMAIL` and `INIT_USER_PASSWORD` and (re)deploy. You can then just log in with this user.

### Disabling new user registration
After you've created your own account on your self-hosted instance, we recommend to set the environment variable `ALLOW_REGISTRATION` to `false`. Otherwise, random people who know your URL can create Fugu accounts on your instance.

## Questions and help
If you have any questions, check out our [GitHub Discussions](https://github.com/shafy/fugu/discussions).
