# Ruby on Rails
Rails is a Ruby web-application framework that includes everything needed to create database-backed web applications according to the [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) (MVC) pattern.

## Stack
- [devise](https://github.com/heartcombo/devise) handles the `User` model, authentication and password encryption.
- [devise-jwt](https://github.com/waiting-for-dev/devise-jwt) adds JWT support to `devise`
- [rubocop](https://rubygems.org/gems/rubocop) for formatting, together with a few plugins; [standard](https://github.com/standardrb/standard), [rubocop-performance](https://github.com/rubocop/rubocop-performance), [rubocop-rails](https://github.com/rubocop/rubocop-rails) and [rubocop-rspec](https://github.com/rubocop/rubocop-rspec)
- [rspec-rails](https://github.com/rspec/rspec-rails) is used as the testing framwork
- [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails) serves as a fixture manager
- [simplecov](https://github.com/simplecov-ruby/simplecov) covers test coverage measurement

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
EDITOR="code --wait" rails credentials:edit
```

It should open a new tmp yml file which should already have a `secret_key_base` key. Create a new `devise_jwt_secret_key` below it and paste the rails secret you created earlier then close the file.

You can now run the application.
```
bundle exec rails server # => To run the server
bundle exec rspec # => To run the tests
bundle exec rubocop # => To run the formatter
```
