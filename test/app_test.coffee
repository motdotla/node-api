request = require 'request'
should  = require 'should'
Person  = require('./../app/models/person')

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
    request.get {url: "http://INVALIDTOKEN:@localhost:3000/api/test/authentication.json"}, (e, res) ->
      json = JSON.parse res.body
      json.success.should.equal(false)
      done()

describe "POST /api/people/create.json", ->
  url = "http://localhost:3000/api/people/create.json"
  json = {email: "scott@scottmotte.com", password: "password"}

  beforeEach (done) ->
    Person.collection.remove (e) ->
      done()

  it "successfully creates", (done) ->
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(true)
      done()

  it "does not create if missing email", (done) ->
    json.email = ""
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(false)
      done()

  it "does not create if missing password", (done) ->
    json.password = ""
    request.post {url: url, json: json}, (e, res) ->
      json = res.body
      json.success.should.equal(false)
      done()

