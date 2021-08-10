# Fugu 🐡

Fugu is a simple, privacy-friendly, open source and self-hostable product analytics.


## Get Fugu
Fugu is still under active development and, while in use by some real-life projects, not publicly launched yet. You can create your account [here](https://app.fugu.lol). I don't recommend using Fugu as your only analytics tool in production yet, because there might be breaking changes and you might lose access to your data (although very unlikely). Please reach out to me at canolcer@hey.com after creating an account so I know somebody else is using it. Of course, you can also clone this repo and self-host the whole thing.

## Docs

Send a `POST` request to `https://app.fugu.lol/api/v1/events` with the following body:

```
{
  api_key: <string>, // Check your Project view (required)
  name: <string>, // Name of your event (required)
  properties: <JSON> // arbitrary JSON containing custom data (optional)
}

```

Replace the domain with your own if you're self-hosting.

## Development
Clone this repo. You'll need Ruby 3.0.0.

### Env variables
```
DATABASE_USER=''
DATABASE_PW=''
DEV_DATABASE=''
TEST_DATABASE=''
```

## Contributing
I didn't have time to write a contribution guide yet. So, here is a quick one: If you want to contribute, create a PR and let me know. Beware: There is no guarantee that I wil add your code to the project - so maybe check first with me before starting to work.

