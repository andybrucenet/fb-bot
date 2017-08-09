########################################################################
# Makefile, ABr
# Project support to build heroku

########################################################################
# standard targets
.PHONY: all build clean rebuild init distclean check-env

all: check-env build

build: check-env

clean: check-env

rebuild: clean build

##############################################################
# git-oriented
.PHONY: commit push

commit: check-env
	@git add --all && [ -n "$(git status --porcelain)" ] && git commit -a || true

push: commit
	@git push heroku master

##############################################################
# utility / non-standard targets

check-env:
ifndef MAKE_WRAPPER_INVOCATION
	$(error Invoke through ./scripts/make-wrapper.sh)
endif

