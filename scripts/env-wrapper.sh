#!/bin/bash
# env-wrapper.sh, ABr

# set user-specific environment variables
HEROKU_ENV_WRAPPER_RC=0
HEROKU_ENV_WRAPPER_PWD="$PWD"
HEROKU_ENV_DIR="$HOME/.lcl-projects/heroku/fb-bot"
if [ -s "$HEROKU_ENV_DIR"/env ] ; then
  cd "$HEROKU_ENV_DIR"
  source ./env
  HEROKU_ENV_WRAPPER_RC=$?
  cd "$HEROKU_ENV_WRAPPER_PWD"
fi
[ $HEROKU_ENV_WRAPPER_RC -ne 0 ] && exit $HEROKU_ENV_WRAPPER_RC

# default values
HEROKU_ENV_FB_PAGE_ACCESS_TOKEN="${HEROKU_ENV_FB_PAGE_ACCESS_TOKEN:-unset-fb-access-token}"
export HEROKU_ENV_FB_PAGE_ACCESS_TOKEN

# call original app
if [ x"$1" != x'source-only' ] ; then
  eval "$@"
fi

