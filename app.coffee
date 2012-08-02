express   = require("express")
app       = express()

app.configure ->
  app.use express.bodyParser()

VALID_EMAIL     = "api@nodejs.org"
VALID_PASSWORD  = "password"
VALID_API_TOKEN = "12345"

class Helper
  @req_basic_auth: (req) ->
    header  = req.headers['authorization']
    return unless header
    token   = header.split(/\s+/).pop()
    auth    = new Buffer(token, 'base64').toString()
    auth.split(/:/)[0]

  @requireApiPerson = (req, res, next) ->
    api_token = Helper.req_basic_auth(req)
    if api_token == VALID_API_TOKEN
      next()
    else
      res.status(401)
      return res.json { success: false, error: {message: "Please use a working authorization token." }}

app.get "/", (req, res) ->
  res.send "API"

app.get "/api/test.json", (req, res) ->
  res.json { success: true }

app.get "/api/test/authentication.json", Helper.requireApiPerson, (req, res) ->
  res.json { success: true }

app.post "/api/sessions.json", (req, res) ->
  if req.body.email == VALID_EMAIL && req.body.password == VALID_PASSWORD
    res.json { success: true, token: VALID_API_TOKEN }
  else
    res.json { success: false, error: { message: "Authentication failed." } }

app.listen 3000