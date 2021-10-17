# Fugu 🐡

Fugu is a simple, privacy-friendly, open source and self-hostable product analytics.


## Get Fugu
There are two ways to use Fugu: Self-hosting or using Fugu Cloud (managed version by us as a SaaS). 

If you don't have the strict need to host Fugu own your own premises, we recommend using Fugu Cloud. It costs $9/month and you don't need to worry about managing your own version, updating, etc.

Our servers are located in the EU (Germany) and your data doesn't leave the EU. We don't track any personal data. Read more in our [privacy policy](https://fugu.lol/legal/privacy).

Head over to [our website](https://fugu.lol) to sign up and get started super duper fast.


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

## Self-hosting

Fugu is and will always be free to host in your own server/cloud. Check out the [self-hosting guide](/blob/main/SELFHOSTING.md) to learn more.

## Contributing

We welcome contributions to Fugu. These can be bug fixes, UI improvements, new features, code quality improvements etc. Check out the [contribution guide](/blob/main/CONTRIBUTING.md) to get started.

## License

This project uses the [GNU Affero General Public License v3.0](https://github.com/mapzy/mapzy/blob/main/LICENSE) license.