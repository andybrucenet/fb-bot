#!/bin/bash
# start-cloudbot.sh, ABr
# Start cloudbot

# expected files
l_cloudbot_pipe='./.localdata/cloudbot_pipe'
l_cloudbot_out='./.localdata/cloudbot_out'
l_cloudbot_msg='./.localdata/cloudbot_msg'

# ensure folder exists
mkdir -p ./.localdata

# get rid of files
echo 'Clean up old files...'
rm -fR "$l_cloudbot_pipe" "$l_cloudbot_out"

# start output
echo 'First-Line' > "$l_cloudbot_msg"

# create pipe
echo 'Create pipe...'
mkfifo "$l_cloudbot_pipe"
echo 'First-Line' > "$l_cloudbot_out"
sleep 1

# start process
echo 'Start cloudbot...'
cd lcl-hubot
npm install
export PATH="node_modules/.bin:node_modules/hubot/node_modules/.bin:$PATH"
echo nohup exec node_modules/.bin/hubot \
  -a shell -n cloudbot < ".$l_cloudbot_pipe" >> ".$l_cloudbot_out" 2>&1 &
sleep 3

# send a couple of messages
echo 'Send initial messages...'
cd ..
echo '' > "$l_cloudbot_pipe"
sleep 1
echo '' > "$l_cloudbot_pipe"
sleep 1

# send PING
echo 'Send ping...'
echo 'cloudbot ping' > "$l_cloudbot_pipe"
sleep 1
echo 'cloudbot ping' > "$l_cloudbot_pipe"
sleep 1
cat "$l_cloudbot_out"

