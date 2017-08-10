#!/bin/bash
# tell-cloudbot.sh, ABr
# Send command to listening cloudbot

# expected files
l_cloudbot_out='./.localdata/cloudbot_out'
l_cloudbot_msg='./.localdata/cloudbot_msg'
l_cloudbot_err='./.localdata/cloudbot_err'
l_cloudbot_dbg='./.localdata/cloudbot_dbg'
l_cloudbot_tell='./.localdata/cloudbot_tell'

# must have something already in output so wc will work
echo "Processing: $@" >> "$l_cloudbot_tell" 2>&1
[ ! -s "$l_cloudbot_msg" ] && echo "Missing $l_cloudbot_msg" && exit 1
if ! grep --quiet -i -e '"pong"' "$l_cloudbot_msg" ; then echo "Cloudbot is dead. Did you kill her?" ; exit 1 ; fi
l_lines=$(wc -l "$l_cloudbot_msg" | awk '{print $1}')
echo "l_lines='$l_lines'" >> "$l_cloudbot_tell" 2>&1

# vars that now apply
export CLOUDBOT_PORT=${CLOUDBOT_PORT:-8001}
export POST_RESPONSE_PORT=${POST_RESPONSE_PORT:-8002}
export HUBOT_POST_RESPONSES_URL="http://localhost:$POST_RESPONSE_PORT/"

# invoke
#set -x
echo curl -X POST http://localhost:8001/receive/general -H "Content-Type: application/json" -d "{\"from\":\"shell\",\"message\":\"cloudbot $*\"}" >> "$l_cloudbot_tell" 2>&1
l_curl_msg=$(curl -X POST http://localhost:8001/receive/general -H "Content-Type: application/json" -d "{\"from\":\"shell\",\"message\":\"cloudbot $*\"}" 2>&1)
l_rc=$?
echo "curl returned $l_rc: '$l_curl_msg'" >> "$l_cloudbot_tell" 2>&1
[ $l_rc -ne 0 ] && echo "Failed to invoke cloudbot" && exit $l_rc
if ! echo "$l_curl_msg" | grep --quiet -i -e '"status":"received"' ; then
  echo "Failed verifying cloudbot invocation" && exit 1
fi

# wait for output
#set -x
l_ctr=1
l_max=10
while true ; do
  l_newlines=$(wc -l "$l_cloudbot_msg" | awk '{print $1}')
  [ $l_lines -ne $l_newlines ] && break
  [ $l_ctr -gt $l_max ] && echo 'Timeout' && exit 1
  sleep 1
  l_ctr=$((l_ctr + 1))
done

# sleep a second to be sure we have output
sleep 1
l_newlines=$(wc -l "$l_cloudbot_msg" | awk '{print $1}')

# get output
echo "Found l_newlines='$l_newlines'; diff='$((l_newlines - l_lines))'" >> "$l_cloudbot_tell" 2>&1
l_tmp="/tmp/tell-cloudbot.$$"
tail -n $((l_newlines - l_lines)) "$l_cloudbot_msg" > "$l_tmp"
while IFS= read -r l_msg; do
  l_msg2=$(echo "$l_msg" | python -c 'import codecs,json,sys;obj=json.load(sys.stdin);UTF8Writer=codecs.getwriter("utf8");sys.stdout=UTF8Writer(sys.stdout);print obj["message"]' | sed -e 's# \?@\+shell \?##g')
  echo "$l_msg2"
done < "$l_tmp"
rm -f "$l_tmp"

# remove terminal escapes and cloudbot prompt
set -x


