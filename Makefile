########################################################################
# Makefile, ABr
# Project support to build heroku project

########################################################################
# standard targets
.PHONY: all build clean run stop clean rebuild

all: check-env build

build: check-env
	@sh -c 'cd lcl-hubot && npm install'
	@npm install

run: build
	@heroku local

stop:
	@kill $(shell ps -v | grep -e 'cloudbot\|start web\|node index\.js' | grep -v grep | awk '{print $$1}')

clean: check-env
	@rm -fR ./node_modules ./.localdata ./lcl-hubot/node_modules

rebuild: clean build

##############################################################
# git-oriented
.PHONY: commit push

commit: check-env
	@git add --all && if [ -n "$$(git status --porcelain)" ] ; then git commit -a ; else true ; fi

push: commit
	@git push heroku master

##############################################################
# utility / non-standard targets
.PHONY: check-env

check-env:
ifndef MAKE_WRAPPER_INVOCATION
	$(error Invoke through ./scripts/make-wrapper.sh)
endif
	@mkdir -p .localdata

