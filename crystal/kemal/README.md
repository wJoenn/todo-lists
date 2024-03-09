# Kemal
[Kemal](https://github.com/kemalcr/kemal) is a "lightning fast", super simple web framework written for Crystal. It takes inspirations from Ruby's Sinatra framework.

## Features
- [x] Connection to a PostgreSQL database
- [x] Task Model
- [x] /tasks routes
- [x] User Model
- [x] JWT authentication
- [x] /users routes
- [x] Working demo
- [x] Specs and ~~test coverage~~ (no existing coverage shard)
- [x] Formatting

## Installation
I recommend using [degit](https://github.com/Rich-Harris/degit) to copy the repo without a remote connection.

Assuming you already have Crystal installed
```bash
npx degit wJoenn/todo-mvcs TodoMVCs
cd TodoMVCs/crystal/kemal
shards install
```

<br>

Now you'll need to generate a new `JWT_SECRET_KEY` ENV variable to be able to launch the application.
First create a new secret key and copy it somewhere
```bash
bin/sam secret
```

Then create a new `.env` file, create a new `JWT_SECRET_KEY` and paste the secret you just created.

<br>

You'll also need create a new `config/database.yml` file, copy the content of the `config/database.example.yml` file and change the `user` with the value echoed by the `whoami` command.

<br>

You can now set the database up and run the application.
```
bin/sam db:setup # Creates the database, run the migrations and initialize the seed
KEMAL_ENV=test bin/sam db:setup # test database needs to be created separately

crystal run src/app.cr # Runs the server
crystal spec spec/ -v --order=random # Runs the tests
bin/ameba # Runs the formatter
```
