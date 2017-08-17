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
  "You are awesome!",
  "=)",
  "Really? What a co-incidence! I love myself too!",
	"It’s ok! You’re only human!",
	"Yes. But, why?",
	"So does my mom, my dad and my friends.",
	"Can you tell me why you wouldn’t?",
	"It’s but natural.",
	"I only wish I could, but I can’t. =(",
	"Welcome to the club. Join immediately. No documents required.",
	"Did you just say something? I’m sorry my ears are hurting, can’t listen.",
	"You must not worry about it anymore. It will pass. Very soon.",
	"You really love me? Can you do me a little favor? Can you just repeat these words in front of my girlfriend and say how special I am? Please?",
	"Yeah.. It’s time you should. It was getting late.",
	"Thank you so much!",
	"Don’t you remember what happened to the last person you said this to?",
	"Hey look behind you! (Runs out of the room as fast as possible...)",
	"This is exactly what someone said and then cheated on me.",
	"If you really love me then you should have known that I just can get close or intimate with anyone. Will that do?"
]

module.exports = (robot)->
  robot.respond /be nice/i, (message)->
    rnd = Math.floor Math.random() * hugs.length
    message.send hugs[rnd]

