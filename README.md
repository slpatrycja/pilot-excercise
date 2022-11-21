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

TODO
