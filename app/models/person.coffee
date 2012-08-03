bcrypt    = require('bcrypt')
mongoose  = require('mongoose')
mongoose.connect('mongodb://localhost/node_api_development')

Schema    = mongoose.Schema
ObjectId  = Schema.ObjectId

class Helpers
  @encryptPassword: (password) ->
    salt = bcrypt.genSaltSync(10)
    hash = bcrypt.hashSync(password, salt)

  @validatePresenceOf = (value) ->
    value and value.length
  
PersonSchema = new Schema(
  email: { type: String, index: { unique: true } }
  crypted_password: { type: String }
)
PersonSchema.virtual("password").set (password) ->
  if !!password
    @crypted_password = Helpers.encryptPassword(password)

PersonSchema.pre "save", (next) ->
  if !Helpers.validatePresenceOf(@crypted_password)
    next new Error("Password required")
  else if !Helpers.validatePresenceOf(@email)
    next new Error("Email required")
  else
    next()

Person = mongoose.model("PersonSchema", PersonSchema)

module.exports = Person