# Ruby on Rails
[Rails](https://github.com/rails/rails) is a Ruby web-application framework that includes everything needed to create database-backed web applications according to the [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) pattern.

## Features
- [x] Connection to a PostgreSQL database
- [x] Task Model
- [x] /tasks routes
- [x] User Model
- [x] JWT authentication
- [x] /users routes
- [x] Specs and test coverage
- [x] Formatting

## Installation
I recommend using [degit](https://github.com/Rich-Harris/degit) to copy the repo without a remote connection.

Assuming you already have Ruby installed
```bash
npx degit wJoenn/todo-mvcs TodoMVCs
cd TodoMVCs/ruby/ruby_on_rails
gem install bundler
bundle install
```

<br>

Now you'll need to generate a new `devise_jwt_secret_key` secret to be able to launch the application.
First create a new secret key and copy it somewhere
```bash
bundle exec rails secret
```

Then delete the `config/credentials.yml.enc` file
```bash
rm -rf config/credentials.yml.enc
```

Then create a new `config/master.key` and a new `config/credentials.yml.enc` with the following command
```bash
EDITOR="code --wait" bundle exec rails credentials:edit
```

It should open a new tmp yml file which should already have a `secret_key_base` key. Create a new `devise_jwt_secret_key` below it and paste the rails secret you created earlier then close the file.

<br>

You can now set the database up and run the application.
```
bundle exec rails db:setup # Creates the database, run the migrations and initialize the seed

bundle exec rails server # => Runs the server
bundle exec rspec # => Runs the tests
bundle exec rubocop # => Runs the formatter
```
