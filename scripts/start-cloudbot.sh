#!/bin/bash
# start-cloudbot.sh, ABr
# Start cloudbot

# expected files
l_cloudbot_out='./.localdata/cloudbot_out'
l_cloudbot_msg='./.localdata/cloudbot_msg'
l_cloudbot_err='./.localdata/cloudbot_err'
l_cloudbot_dbg='./.localdata/cloudbot_dbg'
l_cloudbot_tell='./.localdata/cloudbot_tell'

# ensure folder exists
mkdir -p ./.localdata

# get rid of files
echo 'Clean up old files...'
rm -fR "$l_cloudbot_msg" "$l_cloudbot_err" "$l_cloudbot_out" "$l_cloudbot_dbg"

# start output
echo 'First-Msg' > "$l_cloudbot_msg"
echo 'First-Err' > "$l_cloudbot_err"
echo 'First-Out' > "$l_cloudbot_out"
echo 'First-Dbg' > "$l_cloudbot_dbg"
echo 'First-Tell' > "$l_cloudbot_tell"

# vars that now apply
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"
export CLOUDBOT_PORT=${CLOUDBOT_PORT:-8001}
export PORT=${CLOUDBOT_PORT}
export POST_RESPONSE_PORT=${POST_RESPONSE_PORT:-8002}
export HUBOT_POST_RESPONSES_URL="http://localhost:$POST_RESPONSE_PORT/"
export NODE_VERBOSE=true
export NODE_DEBUG=cluster,net,http,fs,tls,module,timers

# start receiver
echo 'Start python server...'
./scripts/cloudbot-receiver.py $POST_RESPONSE_PORT >>"$l_cloudbot_msg" 2>"$l_cloudbot_err" &
l_rc=$?
[ $l_rc -ne 0 ] && echo "Failed to start python server" && exit $l_rc
sleep 2

# start process
echo 'Start cloudbot...'
cd lcl-hubot
npm install
l_rc=$?
[ $l_rc -ne 0 ] && echo "Failed to npm install" && exit $l_rc
node_modules/.bin/hubot -a http-adapter -n cloudbot >> ".$l_cloudbot_dbg" 2>&1 &
l_rc=$?
[ $l_rc -ne 0 ] && echo "Failed to start cloudbot" && exit $l_rc
sleep 3
cd ..

# send a couple of messages
echo 'Send ping...'
curl -X POST http://localhost:$CLOUDBOT_PORT/receive/general -H "Content-Type: application/json" -d '{"from":"@shell","message":"cloudbot ping"}' && echo ''
sleep 1
curl -X POST http://localhost:$CLOUDBOT_PORT/receive/general -H "Content-Type: application/json" -d '{"from":"@shell","message":"cloudbot ping"}' && echo ''
sleep 1

