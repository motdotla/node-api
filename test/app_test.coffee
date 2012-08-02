request = require 'request'
should  = require 'should'

describe "GET /api/test.json", ->
  url     = "http://localhost:3000/api/test.json"

  it "returns a success response", (done) ->
    request.get {url: url}, (e, res) ->
      json = JSON.parse res.body
      json.success.should.equal(true)
      done()

describe "POST /api/sessions.json", ->
  url     = "http://localhost:3000/api/sessions.json"
  json    = {email: "api@nodejs.org", password: "password"}

  it "correct email/password combo", (done) ->
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(true)
      json.should.have.property('token')
      done()

  it "wrong password", (done) ->
    json.password = "WRONGPASSWORD"
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(false)
      done()

  it "non-existing email", (done) ->
    json.email = "nonexisting@email.com"
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(false)
      done()

describe "GET /api/test/authentication.json", ->
  valid_api_token = "12345"

  it "authenticates with valid api token", (done) ->
    request.get {url: "http://#{valid_api_token}:@localhost:3000/api/test/authentication.json"}, (e, res) ->
      json = JSON.parse res.body
      json.success.should.equal(true)
      done()

  it "does not authenticate with invalid api token", (done) ->
    request.get {url: "http://INVALIDTOKEN:@localhost:3000/api/test/authentication.json"}, (err, res) ->
      json = JSON.parse res.body
      json.success.should.equal(false)
      done()

