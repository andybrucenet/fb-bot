//////////////////////////////////////////////////////////////
// index.js, ABr
// Main page for fb-bot
'use strict'

//////////////////////////////////////////////////////////////
// includes
const express = require('express')
const bodyParser = require('body-parser')
const request = require('request')
const shell = require('shelljs');

//////////////////////////////////////////////////////////////
// globals
const app = express()
const token = process.env.FB_PAGE_ACCESS_TOKEN

//////////////////////////////////////////////////////////////
// local functions

// echo text message
function sendTextMessage(sender, text) {
  let messageData = { text:text }
  request({
    url: 'https://graph.facebook.com/v2.6/me/messages',
    qs: {access_token:token},
    method: 'POST',
    json: {
      recipient: {id:sender},
      message: messageData,
    }
  }, function(error, response, body) {
    if (error) {
      console.log('Error sending messages: ', error)
    } else if (response.body.error) {
      console.log('Error: ', response.body.error)
    }
  })
}

// send a generic message
function sendGenericMessage(sender) {
  let messageData = {
    "attachment": {
      "type": "template",
      "payload": {
        "template_type": "generic",
        "elements": [{
          "title": "First card",
          "subtitle": "Element #1 of an hscroll",
          "image_url": "http://jolstatic.fr/www/captures/1014/5/35145.jpg",
          "buttons": [{
            "type": "web_url",
            "url": "https://www.messenger.com",
            "title": "web url"
          }, {
            "type": "postback",
            "title": "Postback",
            "payload": "Payload for first element in a generic bubble",
          }],
        }, {
          "title": "Second card",
          "subtitle": "Element #2 of an hscroll",
          "image_url": "http://www.360rize.com/wp-content/uploads/2014/11/Gear-VR-no-Background.png",
          "buttons": [{
            "type": "postback",
            "title": "Postback",
            "payload": "Payload for second element in a generic bubble",
          }],
        }]
      }
    }
  }
  request({
    url: 'https://graph.facebook.com/v2.6/me/messages',
    qs: {access_token:token},
    method: 'POST',
    json: {
      recipient: {id:sender},
      message: messageData,
    }
  }, function(error, response, body) {
    if (error) {
      console.log('Error sending messages: ', error)
    } else if (response.body.error) {
      console.log('Error: ', response.body.error)
    }
  })
}

//////////////////////////////////////////////////////////////
// PEP
app.set('port', (process.env.PORT || 5000))

// Process application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({extended: false}))

// Process application/json
app.use(bodyParser.json())

// Index route
app.get('/', function (req, res) {
  res.send('Hello world, I am a chat bot')
})

// for Facebook verification
app.get('/webhook/', function (req, res) {
  if (req.query['hub.verify_token'] === 'my_voice_is_my_password_verify_me') {
    res.send(req.query['hub.challenge'])
  }
  res.send('Error, wrong token')
})

// FB API endpoint to process messages
app.post('/webhook/', function (req, res) {
  let messaging_events = req.body.entry[0].messaging
  for (let i = 0; i < messaging_events.length; i++) {
    let event = req.body.entry[0].messaging[i]
    let sender = event.sender.id
    if (event.message && event.message.text) {
      let text = event.message.text
      if (text === 'Generic') {
        sendGenericMessage(sender)
        continue
      }
      var regexSay = /^say /
      if (text.match(regexSay)) {
        sendTextMessage(sender, text.substring(4, 200) + '?')
      } else {
        // invoke helper
        var the_text = text.substring(0, 200)
        console.log('Invoking cloudbot for "' + the_text + '"')
        shell.exec('./scripts/tell-cloudbot.sh ' + the_text, function(code, stdout, stderr) {
          sendTextMessage(sender, stdout);
          console.log('Exit code:', code);
          console.log('stderr:', stderr);
        });
      }
    }
    if (event.postback) {
     let text = JSON.stringify(event.postback)
     sendTextMessage(sender, "Postback received: "+text.substring(0, 200), token)
     continue
    }
  }
  res.sendStatus(200)
})

// Spin up the server
app.listen(app.get('port'), function() {
  console.log('running on port', app.get('port'))
})

