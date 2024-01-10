# main commands
## command to open R in interactive session
R:
	R --quiet --no-save

## command to remove automatically generated files
clean:
	rm -rf man/*
	rm -rf docs/*
	rm -rf inst/doc/*

# R package development commands
## build docs and run tests
all: man readme test check spellcheck

## build docs
man:
	R --slave -e "devtools::document()"

## reubild readme
readme:
	R --slave -e "rmarkdown::render('README.Rmd')"


## run checks
check:
	devtools::check(args = "--no-multiarch", build_args="--no-multiarch")

## check docs for spelling mistakes
spellcheck:
	echo "\n===== SPELL CHECK =====\n" > spell.log 2>&1
	R --slave -e "devtools::spell_check()" >> spell.log 2>&1

## build entire site
site:
	R --slave -e "pkgdown::clean_site()"
	R --slave -e "pkgdown::build_site(run_dont_run = TRUE, lazy = FALSE)"

## rebuild update files for site
quicksite:
	R --slave -e "pkgdown::build_site(run_dont_run = TRUE, lazy = TRUE)"

## launch local version inside Docker container
## building a temp image for testing, not tagged!
demo:
	docker-compose up --build -d

demo-kill:
	docker-compose down

## launch released version inside Docker container
launch:
	docker run -dp 3838:3838 --name impact -v C:/Github/impactextractions/appdata:/appdata -v C:/Github/impactextractions/appdata/tiles:/appdata/tiles --env DATA_DIRECTORY=/appdata --env TILE_DIRECTORY=/appdata/tiles -it naturecons/impact

launch-kill:
	docker rm --force impact

# Docker commands
## create local image and push to docker
## This will build a local image and then push it to docker Github
## Use this only if dockerhub is failing
## useful for testing different configs (ex. updating library from renv)
image:
	docker build -t naturecons/impact:latest .
	docker push naturecons/impact:latest

## pull the latest image from docker hub
pull:
	docker pull naturecons/impact:latest

## delete all local containers and images
reset:
	docker rm $(docker ps -aq) || \
	docker rmi -f $(docker images -aq)

# renv commands
## snapshot R package dependencies
snapshot:
	R -e "renv::snapshot()"

.PHONY: clean data readme test check install man spellcheck examples site quicksite snapshot deploy demo demo-kill image debug snapshot
