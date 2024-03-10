# Todo MVCs example

I like to dab into a lot of different languages and frameworks to see how the grass is on the other side and when trying out a new framework for the first time I usually make a simple CRUD app with authentication like a todo MVC or a live chat.
I figured it'd help me keep things organized if I stocked all of those examples within a single repository so here it is.

The [client](https://github.com/wJoenn/todo-lists/tree/master/client) directory stores my fronted app.
Made in Vue, purposely very basic because the point of this repo is to test different backend solutions so I don't really care what the two forms I have look like.

## Features
### Database
The APIs connect to a PostgreSQL Database.
The connection preferably is abstracted to an ORM that handles database management through a CLI (create, migrate, seed, drop) and database queries.

### Models
- **Task**
  - The `Task` model belongs to a `user` record
    
  - It has a required `title`
    
  - It has a `completed` status that is `false` by default
    
- **User**
  - The `User` model has many `tasks` records
    
  - It has a required `email` which matches the pattern `/\A[^@\s]+@[^@\s]+\.[a-z]{2,}\z/`
    
  - It has a required `password` which is encrypted before being saved to the database and is hidden from logs
  
  For example
  ```ruby
  #!/usr/bin/env ruby
      
  puts User.first # => #<User id: 1 email: "user@example.com", password: [FILTERED]>
  puts User.first.to_json # => { id: 1, email: "user@example.com" }
  ```
  
  - It can be created with a `password_confirmation` that matches the `password`
    
  - It has a `jti` that is automatically assigned on creation, is reset when signing in and out and is hidden from logs (see `password` example)
    
  - It is authenticable with the `email` and `password`
    
  - It is authenticable with a JWT token

### Routes
- **/tasks**
  - `GET /tasks` requires a `Authorization` header with a `user`'s JWT and renders its `tasks` records as json and a `status :ok`
  
  - `POST /tasks` requires a `Authorization` header with a `user`'s JWT and creates a new `Task` record for that user<br>
  If the `task` is persisted then it renders the `task` as json and a `status: :created`<br>
  Else it renders an array of error messages and a `status: :unprocessable_entity`

  - `DELETE /tasks/:id` requires a `Authorization` header with a `user`'s JWT, deletes the `Task` record and renders a `status: :ok`
 
  - `PATCH /tasks/:id/complete` a `Authorization` header with a `user`'s JWT, updates the `Task` record's `completed` status to `true` and renders that `Task` as json and a `status: :ok`
 
- **/users**
  - `POST /users` creates a new `User` record<br>
  If the `user` is persisted then it renders the `user` as json with a `status: :created` and a `Authorization` header with the `user`'s JWT<br>
  Else it renders an array of error messages and a `status: :unprocessable_entity`

  - `POST /users/sign_in` finds a `User` from the given `email` and `password`<br>
  If the `user` exists then it updates the `user`'s `jti`, renders the `user` as json with a `status: :ok` and a `Authorization` header with the `user`'s JWT<br>
  Else it renders an array of error messages and a `status: :unprocessable_entity`

  - `DELETE /users/sign_out` requires a `Authorization` header with a `user`'s JWT, updates the `user`'s `jti` and renders a `status: :ok`

- **/current_user**
  - `GET /current_user` requires a `Authorization` header with a `user`'s JWT and renders the `user` as json with a `status: :created` and a `Authorization` header with the `user`'s JWT

### Specs
A testing environment is setup and connected to a testing database.
The tests are transactional, meaning any changes to the database done inside an example is rollbacked after each test in order to isolate each test example.
They are also randomised, meaning tests are run in a random order at each itterations.

The tests also include a fixture system to quickly generate record instances.

The coverage for test suite is measured and as close as possible to 100%

### Tooling and CI
Each APIs have their own formatter/linter as well as a CLI task runner.
They also have Github actions for specs, formatting and performance if available.

## Languages
## Crystal
- [Kemal](https://github.com/wJoenn/todo-mvcs/tree/master/crystal/kemal) (Work in progress)

### Ruby
- [Ruby on Rails](https://github.com/wJoenn/todo-lists/tree/master/ruby/ruby_on_rails)
- [Sinatra](https://github.com/wJoenn/todo-lists/tree/master/ruby/sinatra)
