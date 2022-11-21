PROJECT=pilot.co

.PHONY: run
run:
	docker-compose rm -f
	docker-compose pull
	docker compose up --build -d
	docker-compose run contractor-app bin/rails db:create
	docker-compose run contractor-app bin/rails db:migrate
	docker-compose run manager-app bin/rails db:create
	docker-compose run manager-app bin/rails db:migrate
	docker-compose run -d --name contractor-sub contractor-app rake sneakers:run
	docker-compose run -d --name manager-sub manager-app rake sneakers:run

.PHONY: stop
stop:
	docker compose stop
	docker-compose rm -f
	docker stop contractor-sub
	docker stop manager-sub
	docker rm contractor-sub
	docker rm manager-sub

.PHONY: help
help:
	@echo ""
	@echo " ██████╗░██╗██╗░░░░░░█████╗░████████╗░░░░█████╗░░█████╗░"
	@echo " ██╔══██╗██║██║░░░░░██╔══██╗╚══██╔══╝░░░██╔══██╗██╔══██╗"
	@echo " ██████╔╝██║██║░░░░░██║░░██║░░░██║░░░░░░██║░░╚═╝██║░░██║"
	@echo " ██╔═══╝░██║██║░░░░░██║░░██║░░░██║░░░░░░██║░░██╗██║░░██║"
	@echo " ██║░░░░░██║███████╗╚█████╔╝░░░██║░░░██╗╚█████╔╝╚█████╔╝"
	@echo " ╚═╝░░░░░╚═╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░░╚════╝░"
	@echo ""
	@echo " Welcome to $(PROJECT) Makefile."
	@echo " The following commands are available:"
	@echo ""
	@echo "    make run             : Run the application"
	@echo "    make stop            : Stop the servers and remove containers"
	@echo ""
