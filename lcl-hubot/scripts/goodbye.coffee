# Description:
#   Fill your chat with some kindness
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot be nice - just gives some love :)
#
# Author:
#   nesQuick

goodbyes = [
  "Bye.",
  "Later.",
  "Take care."
]

module.exports = (robot)->
  robot.respond /(?:bye|later|see y(?:ou|a)|take care)/i, (msg) ->
    rnd = Math.floor Math.random() * goodbyes.length
    msg.send goodbyes[rnd]

