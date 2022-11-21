```shell
           ██████╗░██╗██╗░░░░░░█████╗░████████╗░░░░█████╗░░█████╗░
           ██╔══██╗██║██║░░░░░██╔══██╗╚══██╔══╝░░░██╔══██╗██╔══██╗
           ██████╔╝██║██║░░░░░██║░░██║░░░██║░░░░░░██║░░╚═╝██║░░██║
           ██╔═══╝░██║██║░░░░░██║░░██║░░░██║░░░░░░██║░░██╗██║░░██║
           ██║░░░░░██║███████╗╚█████╔╝░░░██║░░░██╗╚█████╔╝╚█████╔╝
           ╚═╝░░░░░╚═╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░░╚════╝░
```


## Docker
Before the application setup, it is recommended to install docker. This will allow you to
use the Makefile setup and operate RabbitMQ smoothly. If you're a macOS user, you can do it by running
```shell
brew install docker
```

See [this](https://docs.docker.com/desktop/install/mac-install/) page for more information.

## Getting started

This project includes a Makefile that allows you to test and build the project with simple commands.
To see all available options:
```bash
make help
```

To setup the project run:
```bash
make run
```
This will setup RabbitMQ and two local applications ContractorApp (http://localhost:3000) and ManagerApp (http://localhost:4000)

## Running tests
To run the tests locally, you need to update your `.env.test` files with proper `POSTGRES_USER` values.

Then simply run
```bash
RAILS_ENV=test rails db:create db:migrate
```

and run the tests with
```bash
bundle exec rspec
```

## Implemented features
From the UI perspective, the apps strictly follow 2002ish websites trends (it's not a bug, it's a feature).

![Application UI](https://gcdnb.pbrd.co/images/4KJJrd3olZBU.png?o=1)

In the ContractorApp you can:
- Create payment requests
- Delete payment requests
- See status of your payment requests

In the ManagerApp you can:
- See all received payment requests
- Accept a pending request
- Reject a payment request

## Future improvements

There are a couple of things that would be necessary to improve in this task
if we would like to look into this more deeply:

1. Apply outbox pattern solution

With the current solution, both producers give us at-most-once delivery meaning that
once the database transaction is committed but before the message is sent to the broker,
something bad can happen in our system and the message might not get delivered,
for example because:
- the system can crash;
- the message broker might be unavailable at the given moment.

To provide atomicity of our business operations we could take advantage of the outbox
pattern - that is based on a guaranteed delivery pattern. This could look as follows:

- When saving data do the database eg. creating a payment request, we would also persist
outgoing messages in the same transaction.
- Create a separate process that would check those outgoing messages in the database
table and send them to the message broker.
- After sending each message it should mark it as processed in the database to avoid resending.

There might be a situation in which a given message might be sent multiple times,
which means this solution - outbox pattern - gives us at-least-once delivery.
When using this pattern we should remember that the consumers should be idempotent
when consuming the same message multiple times.

2. Validate inclusion of currency in the list of accepted currencies.

Currently in the UI we can choose one from four currencies: USD, EUR, PLN and GBP.
This, however, is not validated in the backend. We would need database and rails validations
to ensure consistency of data.

3. State machine like ([AASM](https://github.com/aasm/aasm)) to control the state transition
of a payment request.

To not rely only on enum values and custom validations.

4. Convert the `amount` to `amount_in_cents` on the backend, so that a user doesn't have
to convert it on their own in the UI.

Right now the UI is just in the simples form possible.

5. Extract shared code into a separate library.

6. Soft-delete of payment requests or adding a `cancelled` state.

Currently, the contractor can remove a payment request which will be deleted permanently in
both applications (again, for simplicity purposes). This could be handled better by
adding a soft-delete feature or a `cancelled` state.
