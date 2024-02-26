# Todo list example

I like to dab into a lot of different languages and frameworks to see how the grass is like in the neighbour's garden and when trying out a new framework for the first time I usually make a simple CRUD app with authentication like a todo-list or a live chat.
I figured it'd help me keep things organized if I stocked all of those examples within a single repository so here it is.

The [client](https://github.com/wJoenn/todo-lists/tree/master/client) directory stores my fronted app.
Made in Vue, purposely very basic because what the point of this repo is to test different backend solutions so I don't really care what the front looks like not trying out new technologies because I'm very satisfied with Vue.

With each API I try to implement the following features
- Models linked to a PostgreSQL database through an ORM
- CRUD actions to create a task, destroy a task, set a task as completed and get all existing tasks
- Authentication with encrypted password and Json Web Token for client side auth
- Import and export of CSV files containing the tasks
- Transactional tests with fixtures and 100% code coverage
- Linting & Formating
- CLI commands for database management

## Ruby
- [Ruby on Rails](https://github.com/wJoenn/todo-lists/tree/master/ruby/ruby_on_rails) (Work in progress)
- [Sinatra](https://github.com/wJoenn/todo-lists/tree/master/ruby/sinatra) (Work in progress)
