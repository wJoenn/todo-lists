Simple web client made in [Vue](https://github.com/vuejs/core) to demo each APIs with a common frontend app.

It only features very basic forms to sign in, sign up and create a task as well as a few buttons to complete a task, delete it and sign out.
There's also a simple Store to handle client side state management for the user's session.

## Installation
I recommend using [degit](https://github.com/Rich-Harris/degit) to copy the repo without a remote connection.

Assuming you already have Node installed
```bash
npx degit wJoenn/todo-mvcs TodoMVCs
cd TodoMVCs/client
pnpm install

pnpm dev # Runs the server
pnpm lint # Runs the linter
pnpm tsc # Runs the type checker
```
