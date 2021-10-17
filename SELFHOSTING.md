# Self-hosting Guide

We haven't optimized Fugu for self-hosting yet, but we will get to it. We will add some easy deploy options (Digital Ocean, Heroku, Docker) soon.

In the meantime, you can still deploy Fugu if you have a bit of experience.

Fugu is a pretty standard Rails app and you can run it on your favorite cloud infrastructure. When deploying, make sure to include the environment variables from the `.env.example` file. As you can see, there are a few variables that relate to Stripe. Of course, you don't need billing and Stripe if you are self-hosting and you can just leave those empty. Keep in mind that currently clicking on any billing related feature will result in a server error.

Once you have deployed, make sure to connect a Postgres database to the app by setting the `DATABASE_URL` environment variable. To setup the database, run `rails db:setup` in your server's command line.


As a last step, you need to log into the rails console with `rails console` in your server's command line to set up a user:
```
User.create({
  email: "catlover@hey.com",
  password: "santaisnotreal120", 
  password_confirmation: "santaisnotreal120",
  status: "active"
})
```

Now, you can navigate to your domain and log in with the user you just created.

