querystring = require('querystring')

module.exports = (robot) ->
  robot.router.get "/hubot/cmd", (req, res) ->
    query = querystring.parse(req._parsedUrl.query)
    command = query.command
    message = query.message
    robot.emit command, message
    res.end "check log"

    #robot.send(user, message)

