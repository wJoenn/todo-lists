# Sinatra
[Sinatra](https://github.com/sinatra/sinatra) is a framework written in the Ruby language. It’s designed as a simple, but very powerful and flexible way to build web-delivered application without a lot of setup, configuration or effort.

## Features
- [x] Connection to a PostgreSQL database
- [x] Task Model
- [x] /tasks routes
- [x] User Model
- [x] JWT authentication
- [x] /users routes
- [x] Working demo
- [x] Specs and test coverage
- [x] Formatting

## Installation
I recommend using [degit](https://github.com/Rich-Harris/degit) to copy the repo without a remote connection.

Assuming you already have Ruby installed
```bash
npx degit wJoenn/todo-mvcs TodoMVCs
cd TodoMVCs/ruby/sinatra
gem install bundler
bundle install
```

<br>

Now you'll need to generate a new `JWT_SECRET_KEY` ENV variable to be able to launch the application.
First create a new secret key and copy it somewhere
```bash
bundle exec rake secret
```

Then create a new `.env` file, create a new `JWT_SECRET_KEY` and paste the secret you just created.

<br>

You can now set the database up and run the application.
```bash
bin/sinatra db:setup # Creates the database, run the migrations and initialize the seed

bin/dev # Runs the server
bin/rspec # Runs the tests
bundle exec rubocop # Runs the formatter
```
