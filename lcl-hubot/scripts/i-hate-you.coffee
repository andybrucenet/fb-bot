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

hugs = [
  "That really hurts my feelings when you say that. We need to use kind words even when we're mad, OK?",
  "I think that you are very angry right now. After you say sorry to Mommy, I'll show you some ways to get the mad out without making sad choices like saying that.",
  "Wow, you sound really mad! Can you say, 'I'm really mad,' instead?",
  "I don't think you really mean that. Let's take some deep breaths and find out what you did mean.",
  "Would you like a hug or a bubble right now?"
]

module.exports = (robot)->
  robot.respond /i ((hate)|((do not|don't) (like|want))) you/i, (message)->
    rnd = Math.floor Math.random() * hugs.length
    message.send hugs[rnd]

