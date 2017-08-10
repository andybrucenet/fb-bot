#!/bin/bash
# tell-cloudbot.sh, ABr
# Send command to listening cloudbot

# expected files
l_cloudbot_pipe='./.localdata/cloudbot_pipe'
l_cloudbot_out='./.localdata/cloudbot_out'
l_cloudbot_msg='./.localdata/cloudbot_msg'

# must have something already in output so wc will work
[ ! -s "$l_cloudbot_out" ] && echo "Missing $l_cloudbot_out" && exit 1
l_lines=$(wc -l "$l_cloudbot_out" | awk '{print $1}')
echo "Processing: $@" >> "$l_cloudbot_msg" 2>&1
echo "l_lines='$l_lines'" >> "$l_cloudbot_msg" 2>&1

# write input to cloudbot
echo "$*" > "$l_cloudbot_pipe"

# wait for output
#set -x
while true ; do
  l_newlines=$(wc -l "$l_cloudbot_out" | awk '{print $1}')
  [ $l_lines -ne $l_newlines ] && break
done

# sleep a second to be sure we have output
sleep 2
l_newlines=$(wc -l "$l_cloudbot_out" | awk '{print $1}')

# get output
echo "Found l_newlines='$l_newlines'; diff='$((l_newlines - l_lines - 1))'" >> "$l_cloudbot_msg" 2>&1
l_msg=$(tail -n $((l_newlines - l_lines)) "$l_cloudbot_out")

# remove terminal escapes and cloudbot prompt
l_msg2=$(echo "$l_msg" | sed -r "s,\x1B\[[0-9;]*[a-zA-Z],,g" | sed -e 's#cloudbot> ##' | sed -e '/^cloudbot /d' | sed -e 's#,\? @Shell##g' | sed -e 's#^Shell: ##' )

# output to user
echo "$l_msg2"

# some testing stuff
# HEXVAL=$(xxd -pu <<< "$l_msg2") ; echo "'$HEXVAL'"

